# build and tag the images
docker build -t avinashk793/client-app:latest -t avinashk793/client-app:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t avinashk793/server-app:latest -t avinashk793/server-app:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t avinashk793/worker-app:latest  -t avinashk793/worker-app:$GIT_SHA -f ./worker/Dockerfile ./worker

# push docker images to docker hub
docker push avinashk793/cleint-app:latest
docker push avinashk793/server-app:latest
docker push avinashk793/worker-app:latest
docker push avinashk793/cleint-app:$GIT_SHA
docker push avinashk793/server-app:$GIT_SHA
docker push avinashk793/worker-app:$GIT_SHA

# apply all config files to kubernetes cluster
kubectl apply -f k8s

# to take latest images
kubectl set image deployments/server-deployment server=avinashk793/server-app:$GIT_SHA
kubectl set image deployments/client-deployment client=avinashk793/client-app:$GIT_SHA
kubectl set image deployments/worker-deployment worker=avinashk793/worker-app:$GIT_SHA
