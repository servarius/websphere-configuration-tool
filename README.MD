1) Add folder with this code to PATH
2) Use the following commands:



    ${0} -h | --help
    ${0} -h modulename | --help ###for list modules type "-h modules"
    ${0} -m | --mode ##server | node | cell
    ${0} -f | --file ##specify the filename with parameters
    ${0} -t | --taskname ## -s server -S server1 -N Node01 -C Cell01 -t create_jdbc_provider -n....
    ${0} -s | --set-scope ## -s server server1
    -S | --ServerName
    -N | --NodeName
    -C | --CellName
    --DEBUG #for debug mode ON use it BEFORE all args in command line

3) Usage in docker:

```COPY websphere-configuration-tool.tar.gz /
   RUN tar -xzvf /websphere-coqnfiguration-tool.tar.gz -C /tmp/
   ENV PATH="/tmp/websphere-configuration-tool:${PATH}"
   ...
   ...
   RUN tool.sh ARGS...
```
