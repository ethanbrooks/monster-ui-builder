import os

from invoke import task, Collection

from . import test, dc, hub


COLLECTIONS = [test, dc, hub]

ns = Collection()
for c in COLLECTIONS:
    ns.add_collection(c)

ns.configure(dict(
    project='monster-ui-builder',
    repo='monster-ui-builder',
    pwd=os.getcwd(),
    docker=dict(
        user=os.getenv('DOCKER_USER'),
        org=os.getenv('DOCKER_ORG', os.getenv('DOCKER_USER', 'telephoneorg')),
        name='monster-ui',
        tag='%s/%s:latest' % (
            os.getenv('DOCKER_ORG', os.getenv('DOCKER_USER', 'telephoneorg')), 'monster-ui-builder'
        ),
        shell='bash'
    ),
    hub=dict(
        images=['monster-ui-builder']
    )
))
