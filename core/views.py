from rest_framework.decorators import api_view
from rest_framework.response import Response
from .models import SlamResponse, QuizResponse, Note, Favorite


@api_view(['POST'])
def submit_slam(request):
    data = request.data

    SlamResponse.objects.create(
        name=data.get('name'),
        nickname=data.get('nickname'),
        how_met=data.get('how_met'),
        first_impression=data.get('first_impression'),
        favorite_thing=data.get('favorite_thing'),
        describe_in_3_words=data.get('describe_in_3_words'),
        perception_change=data.get('perception_change'),
        vibe=data.get('vibe'),
        cute_habit=data.get('cute_habit'),
        change_habit=data.get('change_habit'),
        grateful_for=data.get('grateful_for'),
        memory=data.get('memory'),
        common_thing=data.get('common_thing'),
        dedicated_song=data.get('dedicated_song'),
        character_type=data.get('character_type'),
        things_to_try=data.get('things_to_try'),
        hobbies=data.get('hobbies'),
        favorite_shows=data.get('favorite_shows'),
        suggestions=data.get('suggestions'),
        unsaid_thing=data.get('unsaid_thing'),
    )

    return Response({"message": "Slam submitted successfully 💛"})


@api_view(['POST'])
def submit_note(request):
    data = request.data

    Note.objects.create(
        name=data.get('name'),
        message=data.get('message')
    )

    return Response({"message": "Note saved 💌"})

@api_view(['POST'])
def submit_quiz(request):
    data = request.data

    # Correct answers (Disha's answers)
    correct_answers = {
        "q1_music": "Romantic",
        "q2_reaction": "Listen quietly and imagine scenarios",
        "q3_food": "Spicy",
        "q4_hangout": "Home",
        "q5_quality": "Honesty",
        "q6_values": "Actions",
        "q7_nature": "Emotional",
        "q8_personality": "Introvert",
        "q9_time": "Night",
        "q10_career": "Creative field",
        "q11_overthinking": "A lot",
    }

    score = 0
    total = len(correct_answers)

    # Calculate score
    for key in correct_answers:
        if data.get(key) == correct_answers[key]:
            score += 1

    match_percentage = int((score / total) * 100)

    # Save in database
    QuizResponse.objects.create(
        name=data.get('name'),
        q1_music=data.get('q1_music'),
        q2_reaction=data.get('q2_reaction'),
        q3_food=data.get('q3_food'),
        q4_hangout=data.get('q4_hangout'),
        q5_quality=data.get('q5_quality'),
        q6_values=data.get('q6_values'),
        q7_nature=data.get('q7_nature'),
        q8_personality=data.get('q8_personality'),
        q9_time=data.get('q9_time'),
        q10_career=data.get('q10_career'),
        q11_overthinking=data.get('q11_overthinking'),
        score=match_percentage
    )

    return Response({
        "message": "Quiz submitted 💛",
        "match_percentage": match_percentage
    })
@api_view(['GET'])
def get_notes(request):
    notes = Note.objects.all().order_by('-created_at')
    data = []

    for note in notes:
        data.append({
            "id": note.id,
            "name": note.name,
            "message": note.message,
            "created_at": note.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        })

    return Response(data)    

@api_view(['GET'])
def get_slam_responses(request):
    slam_responses = SlamResponse.objects.all().order_by('-created_at')
    data = []

    for slam in slam_responses:
        data.append({
            "id": slam.id,
            "name": slam.name,
            "nickname": slam.nickname,
            "how_met": slam.how_met,
            "first_impression": slam.first_impression,
            "favorite_thing": slam.favorite_thing,
            "describe_in_3_words": slam.describe_in_3_words,
            "perception_change": slam.perception_change,
            "vibe": slam.vibe,
            "cute_habit": slam.cute_habit,
            "change_habit": slam.change_habit,
            "grateful_for": slam.grateful_for,
            "memory": slam.memory,
            "common_thing": slam.common_thing,
            "dedicated_song": slam.dedicated_song,
            "character_type": slam.character_type,
            "things_to_try": slam.things_to_try,
            "hobbies": slam.hobbies,
            "favorite_shows": slam.favorite_shows,
            "suggestions": slam.suggestions,
            "unsaid_thing": slam.unsaid_thing,
            "created_at": slam.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        })

    return Response(data)

@api_view(['GET'])
def get_quiz_responses(request):
    quiz_responses = QuizResponse.objects.all().order_by('-created_at')
    data = []

    for quiz in quiz_responses:
        data.append({
            "id": quiz.id,
            "name": quiz.name,
            "q1_music": quiz.q1_music,
            "q2_reaction": quiz.q2_reaction,
            "q3_food": quiz.q3_food,
            "q4_hangout": quiz.q4_hangout,
            "q5_quality": quiz.q5_quality,
            "q6_values": quiz.q6_values,
            "q7_nature": quiz.q7_nature,
            "q8_personality": quiz.q8_personality,
            "q9_time": quiz.q9_time,
            "q10_career": quiz.q10_career,
            "q11_overthinking": quiz.q11_overthinking,
            "score": quiz.score,
            "created_at": quiz.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        })

    return Response(data)