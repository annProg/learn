from django.db import models

# Create your models here.

class Blog(models.Model):
    title = models.CharField('标题', max_length=200)
    author = models.ForeignKey('auth.User', on_delete=models.SET_NULL, null=True, verbose_name='作者')
    content = models.TextField('内容')

    def _str_(self):
        return self.title
