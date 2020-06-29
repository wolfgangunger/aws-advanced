## create Elastic Beanstalk environment

#   create the sample app
eb init

# create a simple index file
echo "Hello AWS Friends" > index.html

# create the env
eb create int-env

# deploy the env
eb deploy

# open the app in browser
eb open

# see the status
eb status

# check health
eb health

# cleanup
eb terminate