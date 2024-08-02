name: Docker Build and Push

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  build-and-push:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout repository
      uses: actions/checkout@v3

    - name: Set up Docker Buildx
      uses: docker/setup-buildx-action@v2

    - name: Log in to DockerHub
      uses: docker/login-action@v2
      with:
        username: ${{ secrets.DOCKER_USERNAME }}
        password: ${{ secrets.DOCKER_PASSWORD }}

    - name: Build Docker image
      run: docker build -t my-node-app .

    - name: Tag Docker image
      run: docker tag my-node-app ${{ secrets.DOCKER_USERNAME }}/my-node-app:latest

    - name: Push Docker image to DockerHub
      run: docker push ${{ secrets.DOCKER_USERNAME }}/my-node-app:latest

    - name: Run Docker container
      run: docker run -d -p 3000:3000 --name my-node-app ${{ secrets.DOCKER_USERNAME }}/my-node-app:latest
      run: curl -f http://localhost:3000 || exit 1

    - name: Wait for the application to start
      run: sleep 15      

    - name: Show Docker logs for debugging
      if: failure()
      run: docker logs my-node-app
