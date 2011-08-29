"""
This file demonstrates two different styles of tests (one doctest and one
unittest). These will both pass when you run "manage.py test".

Replace these with more appropriate tests for your application.
"""

from django.test import TestCase, Client

from elementtree.ElementTree import parse
from common.xml import xmldict_to_pydict
import re

from profiles.models import User
from friends.models import *
from django.core import serializers


class BaseTestCase(TestCase):

    def _sort_by_pk(self, list_or_qs):
        # decorate, sort, undecorate using the pk of the items
        # in the list or queryset
        annotated = [(item.pk, item) for item in list_or_qs]
        annotated.sort()
        return map(lambda item_tuple: item_tuple[1], annotated)
    
    def assertQuerysetEqual(self, a, b):
        # assert list or queryset a is the same as list or queryset b
        return self.assertEqual(self._sort_by_pk(a), self._sort_by_pk(b))


class SimpleTest(BaseTestCase):
    
    def test_find_view(self):
        """

        """
        
        names = ('Bob', 'Barb', 'Alice', 'John')
        users = {}
        for i, name in enumerate(names):
            users[name] = User.objects.create(
                UDID="ABCDEFGHIJKLMNOP%d" % i,
                name=name, 
                phone='15555555555', 
                email="%s@test.com" % name
            )
        
        c = Client()
        
        response = c.post('/friends/find/', {'email': 'Alise@test.com'})
        self.assertEqual(response.status_code, 200)
        self.assertTrue(re.search('\"results\":null', re.sub("\s+", "", response.content)))

        response = c.post('/friends/find/', {'email': 'Alice@test.com'})
        self.assertEqual(response.status_code, 200)
        self.assertTrue(re.search('\"UDID\":\"ABCDEFGHIJKLMNOP2\"', re.sub("\s+", "", response.content)))

    def test_invite_requests_accept_view(self):
        """

        """
        
        names = ('Bob', 'Barb', 'Alice', 'John')
        users = {}
        for i, name in enumerate(names):
            users[name] = User.objects.create(
                UDID="ABCDEFGHIJKLMNOP%d" % i,
                name=name, 
                phone='15555555555', 
                email="%s@test.com" % name
            )
        
        c = Client()
        
        response = c.post('/friends/invite/', {'from': 'ABCDEFGHIJKLMNOP0', 'to': 'ABCDEFGHIJKLMNOP2'})
        self.assertEqual(response.status_code, 200)
        
        response = c.post('/friends/requests/', {'UDID': 'ABCDEFGHIJKLMNOP2'})
        self.assertEqual(response.status_code, 200)
        self.assertTrue(re.search('\"UDID\":\"ABCDEFGHIJKLMNOP0\"', re.sub("\s+", "", response.content)))
        
        response = c.post('/friends/accept/', {'from': 'ABCDEFGHIJKLMNOP0', 'to': 'ABCDEFGHIJKLMNOP2'})
        self.assertEqual(response.status_code, 200)
        self.assertFalse(re.search('\"success\":null', re.sub("\s+", "", response.content)))

    
    def test_friendship(self):
        """

        """

        names = ('Bob', 'Barb', 'Alice', 'John')
        users = {}
        for i, name in enumerate(names):
            users[name] = User.objects.create(
                UDID="ABCDEFGHIJKLMNOP%d" % i,
                name=name, 
                phone='15555555555', 
                email="%s@test.com" % name
            )
        
        fi = FriendshipInvitation.objects.create(
                from_user=users['Bob'],
                to_user=users['Alice'],
                )
        self.assertEqual(fi.status, "1") 
        fi.accept()
        self.assertEqual(fi.status, "5")
        
        self.assertQuerysetEqual(friend_set_for(users['Bob']), User.objects.filter(name='Alice'))
        
