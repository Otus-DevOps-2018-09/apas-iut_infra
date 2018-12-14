gcloud compute instances create reddit-app --zone europe-west1-b \
--image-family=reddit-full --machine-type=g1-small --network=default \
--boot-disk-type=pd-standard --tags=reddit-app

