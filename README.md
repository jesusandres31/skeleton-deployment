# Skeleton-Deployment 🚀🛠️⚙️🧑🏻‍💻

This repository contains the base configurations required to deploy monolithic web applications in a VPC.

<br/>
<hr/>

## Configured Environments

The repository currently supports three environments:

- `development`
- `staging` (or `qa`)
- `production`

<br/>
<hr/>

## How to Use the Repository

Follow these steps to use the repository in your project:

### 1) Add the Repository to Your Project

You can either fork the repository and add it to your project, or clone it and then remove the .git folder.

Assuming your project has the following structure:

```
/project/
    - project-back
    - project-front
```

You should add the repository as follows:

```
/project/
    - project-back
    - project-front
    - project-deploy
```

### 2) Use GitLab Container Registry

Go to GitLab and create a project with the same name as your application (e.g., someapp). If you are already using GitLab, simply add the repository to your project.

Once you are inside the project, go to "Packages & Registries" and then to "Container Registry". You will see example commands similar to the following:

```
docker build -t registry.gitlab.com/someuser/someapp .
docker push registry.gitlab.com/someuser/someapp
```

Next, log in to the Container Registry using the command line in your computer:
Navigate to the project-deployment directory and enter the following commands:

```
docker login registry.gitlab.com
username: (your GitLab username)
password: (use an access token here)
```

### 3) Replace the Variables in `config/.env`

Edit the .env file in the config directory to replace the following variables:

- `REPO_NAME`: The name of your application's repository.
- `USERNAME`: Your GitLab username.
- `BRANCH`: The name of the Git branch that you want to deploy.
- `BACKEND`: The suffix of your backend service (e.g. "back" or "backend").
- `FRONTEND`: The suffix of your frontend service (e.g. "front" or "frontend").
- `APP_PORT`: The port number that your application runs on.
- `API_PORT`: The port number that your backend API runs on.
- `DB_PASSWORD`: The password for the PostgreSQL database that your application uses.
- `DB_USER`: The username for the PostgreSQL database.
- `DB_DATABASE`: The name of the PostgreSQL database.

<br/>
<hr/>

# # TODO:

The following tasks need to be completed:

- Update the `proxy/nginx.conf` file to use the port numbers specified in the `config/.env` file..

- Consider adding more Git branches to the repository, to support different phases of the software development life cycle.

- Add the possibility to build the Docker images directly on the VPS. This will allow for more flexibility in the deployment process and eliminate the need for a separate build server.
