# Test task for MAXA Tech LLP

## Getting started
```
$ git clone https://github.com/MikolaPy/test-job.git
$ cd test-job
```
Build docker 
```
$ docker compose up --build
```
Make database migrations
```
$ rake db:migrate
```
Run the test
```
$ bundle exec rspec
