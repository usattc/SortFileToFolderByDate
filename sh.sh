RED='\033[0;31m'
Blue='\033[0;34m'
Cyan='\033[0;36m'
Orange='\033[0;33m'
NC='\033[0m' # No Color

# 是否要移入子文件夹, '' 则不移
# 子文件夹有空格用正常空格
subFolder=''
subFolderSize=${#subFolder}

for file in *; do
# 过滤文件后缀
if [ "${file##*.}"x = "sh"x ]
    then
    echo "${Blue}$file 跳过${NC}"
    continue
fi

if [[ -d $file ]]
    then
    echo "${Blue}$file 是文件夹${NC}"
    continue
elif [[ -f $file ]]
    then
    # 按修改日期, 方法一:
#    folder=`date -r $file +"%Y-%m-%d";`
    # 按修改日期, 方法二:
    folder=`stat -f "%Sm" -t "%Y-%m-%d" $file`
    # 按创建日期:
#    folder=`stat -f "%SB" -t "%Y-%m-%d" $file`
    echo "${Orange}$file - $folder${NC}"
    
    if [ -d "$folder" ]
        then
        echo "${Blue}文件夹已存在${NC}"
    else
        mkdir "$folder"
        echo "${Blue}创建文件夹${NC}"
    fi
    
    # 需要处理子文件夹
    if [ 1 -eq "$(echo "${subFolderSize} > 0" | bc)" ]
        then
        cd $folder
        
        if [ -d "$subFolder" ]
            then
            echo "${Blue}子文件夹已存在${NC}"
        else
            mkdir "$subFolder"
            echo "${Blue}创建子文件夹${NC}"
        fi
        
        cd ..
        mv $file "$folder/$subFolder"
        echo "${Blue}移入子文件夹 $subFolder${NC}"
    else
        mv $file $folder
    fi
else
    echo "${RED}$file 异常${NC}"
    exit 1
fi
done
