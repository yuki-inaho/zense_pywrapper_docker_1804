# Running builds
1. Clone codes and a submodule (In the case of "tmp" is working directory)
```
mkdir -p tmp && cd tmp
git clone https://github.com/yuki-inaho/zense_pywrapper_docker_1804.git --recursive
```

2. Build Dockerfile
```
cd zense_pywrapper_docker_1804/
make build
```

# Operation check
1. Move the working directory to the above one, and execute a script (picozense_pywrapper/main.py).
```
cd tmp
make run
```
