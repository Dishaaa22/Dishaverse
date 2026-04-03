from django.contrib import admin
from .models import SlamResponse, QuizResponse, Note, Favorite

admin.site.register(SlamResponse)
admin.site.register(QuizResponse)
admin.site.register(Note)
admin.site.register(Favorite)
