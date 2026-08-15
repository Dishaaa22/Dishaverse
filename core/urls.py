from django.urls import path
from .views import (
    slam_view,
    quiz_view,
    note_view,
    favorites_view,
    slam_responses_view,
    quiz_responses_view,
    notes_view,
    favorites_responses_view,
)

urlpatterns = [
    path("slam/", slam_view, name="slam"),
    path("quiz/", quiz_view, name="quiz"),
    path("note/", note_view, name="note"),
    path("favorites/", favorites_view, name="favorites"),
    path("slam-responses/", slam_responses_view, name="slam_responses"),
    path("quiz-responses/", quiz_responses_view, name="quiz_responses"),
    path("notes/", notes_view, name="notes"),
    path("favorites-responses/", favorites_responses_view, name="favorites_responses"),
]