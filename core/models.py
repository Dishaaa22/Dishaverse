from django.db import models

# Slam Book Responses
class SlamResponse(models.Model):
    name = models.CharField(max_length=100)
    nickname = models.CharField(max_length=100)
    how_met = models.TextField()
    first_impression = models.TextField()
    favorite_thing = models.TextField()
    describe_in_3_words = models.CharField(max_length=200)
    perception_change = models.TextField()
    vibe = models.CharField(max_length=100)
    cute_habit = models.TextField()
    change_habit = models.TextField()
    grateful_for = models.TextField()
    memory = models.TextField()
    common_thing = models.TextField()
    dedicated_song = models.CharField(max_length=200)
    character_type = models.CharField(max_length=100)
    things_to_try = models.TextField()
    hobbies = models.TextField()
    favorite_shows = models.TextField()
    suggestions = models.TextField()
    unsaid_thing = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Slam - {self.name}"

# Quiz Responses
class QuizResponse(models.Model):
    name = models.CharField(max_length=100)
    q1_music = models.CharField(max_length=100)
    q2_reaction = models.CharField(max_length=100)
    q3_food = models.CharField(max_length=100)
    q4_hangout = models.CharField(max_length=100)
    q5_quality = models.CharField(max_length=100)
    q6_values = models.CharField(max_length=100)
    q7_nature = models.CharField(max_length=100)
    q8_personality = models.CharField(max_length=100)
    q9_time = models.CharField(max_length=100)
    q10_career = models.CharField(max_length=100)
    q11_overthinking = models.CharField(max_length=100)
    score = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Quiz - {self.name} ({self.score}%)"

# Notes for Disha
class Note(models.Model):
    name = models.CharField(max_length=100)
    message = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Note - {self.name}"


# Favorites Section
class FavoriteResponse(models.Model):
    name = models.CharField(max_length=100)
    favorite_food = models.CharField(max_length=255, blank=True)
    favorite_song_type = models.CharField(max_length=255, blank=True)
    favorite_place = models.CharField(max_length=255, blank=True)
    favorite_movie_vibe = models.CharField(max_length=255, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Favorites - {self.name}"