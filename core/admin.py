from django.contrib import admin
from .models import SlamResponse, QuizResponse, Note, FavoriteResponse


@admin.register(SlamResponse)
class SlamResponseAdmin(admin.ModelAdmin):
    list_display = ("name", "created_at")
    search_fields = ("name",)


@admin.register(QuizResponse)
class QuizResponseAdmin(admin.ModelAdmin):
    list_display = ("name", "score", "created_at")
    search_fields = ("name",)


@admin.register(Note)
class NoteAdmin(admin.ModelAdmin):
    list_display = ("name", "created_at")
    search_fields = ("name", "message")


@admin.register(FavoriteResponse)
class FavoriteResponseAdmin(admin.ModelAdmin):
    list_display = ("name", "favorite_food", "favorite_place", "created_at")
    search_fields = ("name", "favorite_food", "favorite_song_type", "favorite_place", "favorite_movie_vibe")