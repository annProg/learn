用parallel命令，更方便
```
head host/new.list |awk '{print $1}' |parallel -j 50 ./ssh.sh hostname {}
```
