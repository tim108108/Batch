### 使用方法
1. Linux 直接執行 `.sh` 檔
2. Windows: 點選 `Win2shell.bat`

### genfile.sh Example
產生指定大小的檔案，使用0~128數字填充
- 產生1MB的檔案: `sh genfile.sh 1MB`
- 產生10MB的檔案: `sh genfile.sh 10MB`
- 執行結果為`檔案大小_G.txt`

### disk.sh Example
透過`cp`搬檔案測試
> Linux 需要將磁碟 mount 在`/mnt`之下，如`/mnt/d/`
- Linux 使用 1MB 檔案測試 D 槽: `sh disk.sh d 1MB_G.txt`
- Windows 使用 10MB 檔案測試 D 槽: `sh disk.sh d 10MB_G.txt`

### nic.sh Example
透過`ftp`搬檔案測試
> Linux 可能需要 sudo
- Linux 使用 1MB 檔案測試 1.1.1.1: `sh nic.sh 1.1.1.1 1MB_G.txt`
- Windows 使用 10MB 檔案測試 localhost: `sh nic.sh localhost 10MB_G.txt`