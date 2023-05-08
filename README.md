# Skeleton-Deployment

repository with base configurations to deploy monolitic web applications in a VPC

## environments

- `development`
- `staging` (or `qa`)
- `production`

## keys

- `someapp`: the name of the application.
- `someuser`: the name of the user.

## how to use it

go to gitlab and create a project with the name of your project e.g someapp

enter the project

in "package and register" go to "container registry"

docker login registry.gitlab.com
username
password: use an access tocken here

docker build -t registry.gitlab.com/someuser/someapp .

docker push registry.gitlab.com/someuser/someapp
