from django.urls import path
from .views import submit_slam, submit_note, submit_quiz, get_notes, get_slam_responses, get_quiz_responses

urlpatterns = [
    path('slam/', submit_slam),
    path('note/', submit_note),
    path('quiz/', submit_quiz),
    path('notes/', get_notes),
    path('slam-responses/', get_slam_responses),
    path('quiz-responses/', get_quiz_responses),
]