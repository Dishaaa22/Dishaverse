import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .models import SlamResponse, QuizResponse, Note, FavoriteResponse
from django.core.mail import send_mail
from django.conf import settings


QUIZ_ANSWERS = {
    "q1_music": "Romantic",
    "q2_reaction": "Listen quietly and imagine scenarios",
    "q3_food": "Spicy",
    "q4_hangout": "Trip",
    "q5_quality": "Loyalty",
    "q6_values": "Effort",
    "q7_nature": "Emotional",
    "q8_personality": "Ambivert",
    "q9_time": "Night",
    "q10_career": "Creative field",
    "q11_overthinking": "A lot",
}


@csrf_exempt
def slam_view(request):
    if request.method == "POST":
        data = json.loads(request.body)

        slam = SlamResponse.objects.create(
            name=data.get("name", ""),
            nickname=data.get("nickname", ""),
            how_met=data.get("how_met", ""),
            first_impression=data.get("first_impression", ""),
            favorite_thing=data.get("favorite_thing", ""),
            describe_in_3_words=data.get("describe_in_3_words", ""),
            perception_change=data.get("perception_change", ""),
            vibe=data.get("vibe", ""),
            cute_habit=data.get("cute_habit", ""),
            change_habit=data.get("change_habit", ""),
            grateful_for=data.get("grateful_for", ""),
            memory=data.get("memory", ""),
            common_thing=data.get("common_thing", ""),
            dedicated_song=data.get("dedicated_song", ""),
            character_type=data.get("character_type", ""),
            things_to_try=data.get("things_to_try", ""),
            hobbies=data.get("hobbies", ""),
            favorite_shows=data.get("favorite_shows", ""),
            suggestions=data.get("suggestions", ""),
            unsaid_thing=data.get("unsaid_thing", ""),
        )

        return JsonResponse({"message": "Slam response saved", "id": slam.id})

    return JsonResponse({"error": "Only POST allowed"}, status=405)

slam = serializer.save()

send_mail(
    subject=f"New Slam from {slam.name}",
    message=f"""
Name: {slam.name}
Nickname: {slam.nickname}
How met: {slam.how_met}
First impression: {slam.first_impression}
Favorite thing: {slam.favorite_thing}
3 words: {slam.describe_in_3_words}
Memory: {slam.memory}
Message: {slam.unsaid_thing}
""",
    from_email=settings.DEFAULT_FROM_EMAIL,
    recipient_list=[settings.EMAIL_HOST_USER],
    fail_silently=False,
)

@csrf_exempt
def quiz_view(request):
    if request.method == "POST":
        data = json.loads(request.body)

        score = 0
        total = len(QUIZ_ANSWERS)

        for key, correct_answer in QUIZ_ANSWERS.items():
            if data.get(key) == correct_answer:
                score += 1

        match_percentage = int((score / total) * 100)

        quiz = QuizResponse.objects.create(
            name=data.get("name", ""),
            q1_music=data.get("q1_music", ""),
            q2_reaction=data.get("q2_reaction", ""),
            q3_food=data.get("q3_food", ""),
            q4_hangout=data.get("q4_hangout", ""),
            q5_quality=data.get("q5_quality", ""),
            q6_values=data.get("q6_values", ""),
            q7_nature=data.get("q7_nature", ""),
            q8_personality=data.get("q8_personality", ""),
            q9_time=data.get("q9_time", ""),
            q10_career=data.get("q10_career", ""),
            q11_overthinking=data.get("q11_overthinking", ""),
            score=match_percentage,
        )

        return JsonResponse({
            "message": "Quiz submitted successfully",
            "id": quiz.id,
            "match_percentage": match_percentage,
        })

    return JsonResponse({"error": "Only POST allowed"}, status=405)


@csrf_exempt
def note_view(request):
    if request.method == "POST":
        data = json.loads(request.body)

        note = Note.objects.create(
            name=data.get("name", ""),
            message=data.get("message", ""),
        )

        return JsonResponse({"message": "Note saved", "id": note.id})

    return JsonResponse({"error": "Only POST allowed"}, status=405)


@csrf_exempt
def favorites_view(request):
    if request.method == "POST":
        data = json.loads(request.body)

        favorite = FavoriteResponse.objects.create(
            name=data.get("name", ""),
            favorite_food=data.get("favorite_food", ""),
            favorite_song_type=data.get("favorite_song_type", ""),
            favorite_place=data.get("favorite_place", ""),
            favorite_movie_vibe=data.get("favorite_movie_vibe", ""),
        )

        return JsonResponse({"message": "Favorites saved", "id": favorite.id})

    return JsonResponse({"error": "Only POST allowed"}, status=405)


def slam_responses_view(request):
    responses = list(
        SlamResponse.objects.order_by("-created_at").values()
    )
    return JsonResponse(responses, safe=False)


def quiz_responses_view(request):
    responses = list(
        QuizResponse.objects.order_by("-created_at").values()
    )
    return JsonResponse(responses, safe=False)


def notes_view(request):
    notes = list(
        Note.objects.order_by("-created_at").values()
    )
    return JsonResponse(notes, safe=False)


def favorites_responses_view(request):
    responses = list(
        FavoriteResponse.objects.order_by("-created_at").values()
    )
    return JsonResponse(responses, safe=False)