#!/bin/bash

file=$1
sed -i '/^$/d' $file
sed -i "s/保送//g" $file
sed -i "s/考取//g" $file
sed -i "s/研究生//g" $file
sed -i "s/博士生//g" $file
sed -i "s/.*\(华为\).*/\1/g" $file
sed -i "s/.*\(中国移动\).*/\1/g" $file
sed -i "s/.*\(中国电信\).*/\1/g" $file
sed -i "s/.*\(中国科学院\).*/\1/g" $file
sed -i "s/.*\(中国联合网络通信\).*/中国联通/g" $file
sed -i "s/.*中国联通.*/中国联通/g" $file
sed -i "s/\(.*银行\).*行.*/\1/g" $file
sed -i "s/.*\(利为\).*/多益游戏/g" $file
sed -i "s/.*\(明源软件\).*/\1/g" $file
sed -i "s/.*\(解放军\).*/\1/g" $file

sed -i "s/\(.*公司\).*分公司/\1/g" $file
sed -i "s/\(.*公司\).*研究所/\1/g" $file
sed -i "s/\(.*银行\).*/\1/g" $file
sed -i "s/\(.*集团\).*/\1/g" $file
sed -i "s/\(.*局\).*/\1/g" $file
sed -i "s/.*\(公务员\).*/\1/g" $file
sed -i "s/.*\(中移（苏州）\).*/中国移动/g" $file
sed -i "s/.*\(解放军\).*/\1/g" $file

sed -i "s/.*\(读书郎\).*/珠海读书郎/g" $file
sed -i "s/.*\(读书朗\).*/珠海读书郎/g" $file
sed -i -E  "s/.*新浪网.*|.*微梦创科.*|.*新浪互联.*/新浪/g" $file
sed -i -E  "s/.*国网.*|.*国家电网.*/国家电网/g" $file
sed -i -E  "s/.*奇智软件.*|.*奇虎.*/奇虎360/g" $file
sed -i -E  "s/.*阿里巴巴.*|.*淘宝.*|.*阿里集团.*|.*支付宝.*|.*阿里云.*/阿里巴巴/g" $file

