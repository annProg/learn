from django.contrib import admin
from blog.models import Blog

# Register your models here.

@admin.register(Blog)
class BlogAdmin(admin.ModelAdmin):
    list_display = ['title', 'author']
    search_fields = ['title','content', 'author__username']
    readonly_fields = ['author']

    def save_model(self, request, obj, form, change):
        if not change:
            obj.author = request.user
            super(BlogAdmin, self).save_model(request, obj, form, change)

