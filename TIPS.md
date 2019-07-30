## Tips
Xóa cổng đang chạy

```
Mac & Linux: 
lsof -wni tcp:3000 
kill -9 xxxx

Windows: 
netstat -ano | findstr :3000
taskkill /PID xxx /F
```
 
 
## Install & Run on Windows
### Error 
While executing gem ... (Encoding::ConverterNotFoundError)
    code converter not found (UTF-16LE to Windows-1258)
    
`chcp 850`

### Set proxy on windows
#### Yarn
yarn config set proxy %HTTP_PROXY%
yarn config set https-proxy %HTTPS_PROXY%
 