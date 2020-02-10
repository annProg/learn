# allitebooks

- first run `./books.sh startpage endpage`
- then run `./download.sh`

## 错误处理

可能有些文件下载失败，运行 `error.sh`，找出失败的文件，写入 `pages/error.txt`，然后使用 `./download.sh` 重新下载