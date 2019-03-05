#!/bin/bash
ver="v1.9.2 Beta 5"
title="Breeze Easy Shell"
title_full="$title $ver"
#-----------------
#типовые функции
#-----------------

#для рабты с цветами
green='\033[0;32m'
normal='\033[0m'

#функция, которая запрашивает только один символ
myread()
{
temp=""
while [ -z "$temp" ] #защита от пустых значений
do
read -n 1 temp
done
eval $1=$temp
echo
}

#функция, которая запрашивает только да или нет
myread_yn()
{
temp=""
while [[ "$temp" != "y" && "$temp" != "Y" && "$temp" != "n" && "$temp" != "N" ]] #запрашиваем значение, пока не будет "y" или "n"
do
echo -n "y/n: "
read -n 1 temp
echo
done
eval $1=$temp
}

#функция, которая запрашивает только цифру
myread_dig()
{
temp=""
counter=0
while [[ "$temp" != "0" && "$temp" != "1" && "$temp" != "2" && "$temp" != "3" && "$temp" != "4" && "$temp" != "5" && "$temp" != "6" && "$temp" != "7" && "$temp" != "8" && "$temp" != "9" ]] #запрашиваем значение, пока не будет цифра
do
if [ $counter -ne 0 ]; then echo -n "Неправильный выбор. Ведите цифру: "; fi
let "counter=$counter+1"
read -n 1 temp
echo
done
eval $1=$temp
}

#функция установки с проверкой не установлен ли уже пакет
myinstall()
{
if [ -z `rpm -qa $1` ]; then
	yum -y install $1
else
	echo "Пакет $1 уже установлен"
	br
fi
}

title()
{
clear
echo "$title"
}

menu()
{
clear
echo "$menu"
echo "Выберите пункт меню:"
}

wait()
{
echo "Нажмите любую клавишу, чтобы продолжить..."
read -s -n 1
}

br()
{
echo ""
}

updatescript()
{
wget $updpath/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
}

settimezone()
{
/bin/cp /usr/share/zoneinfo/$1/$2  /etc/localtime
echo "Новый часовой пояс установлен. Текущее время: $(date +%H:%M)."
wait
}
repo () {
	osver1_repo=$osver1 #дальше будем работать с локальной переменной
	if [ $osver1_repo -eq 0 ]; then
	    echo "Мы не смогли определить версию Вашей ОС, но Вы можете выбрать её сами на свой страх и риск:"
        echo "4) CentOS 4.x (или другой дистрибутив на базе RHEL 4)"
        echo "5) CentOS 5.x (или другой дистрибутив на базе RHEL 5)"
        echo "6) CentOS 6.x (или другой дистрибутив на базе RHEL 6)"
        echo "7) CentOS 7.x (или другой дистрибутив на базе RHEL 7)"
        echo "0) Любая другая ОС"
        myread_dig osver_user
        if [ $osver_user -eq 0 ]; then echo "Никакие другие ОС пока не поддерживаются."
			else
			osver1_repo=$osver_user
        fi
	fi
      case "$osver1_repo" in
        4)
        echo "Будут добавлены репозитории для CentOS 4"
		wait
		echo "Устанавливаем репозитории..."
		case "$arc" in
			32)
			wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el4.rf.i386.rpm
			rpm -Uvh rpmforge-release-0.5.2-2.el4.rf.i386.rpm
			;;
			64)
			wget http://packages.sw.be/rpmforge-release/rpmforge-release-0.5.2-2.el4.rf.x86_64.rpm
			rpm -Uvh rpmforge-release-0.5.2-2.el4.rf.x86_64.rpm
			;;
		esac
        ;;
        5)
		echo "Будут добавлены репозитории EPEL, REMI, RepoForge (бывший RPMForge) и ELRepo для CentOS 5"
		wait
		echo "Устанавливаем репозитории..."
		yum -y install epel-release
		rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-5.rpm
			case "$arc" in
				32)
				rpm -ivh http://repository.it4i.cz/mirrors/repoforge/redhat/el5/en/i386/rpmforge/RPMS/rpmforge-release-0.5.3-1.el5.rf.i386.rpm
				;;
				64)
				rpm -ivh http://repository.it4i.cz/mirrors/repoforge/redhat/el5/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el5.rf.x86_64.rpm
				;;
			esac
		rpm -Uvh http://www.elrepo.org/elrepo-release-5-5.el5.elrepo.noarch.rpm
        ;;
        6)
		echo "Будут добавлены репозитории EPEL, REMI, RepoForge (бывший RPMForge) и ELRepo для CentOS 6"
		wait
		echo "Устанавливаем репозитории..."
			#epel remi
			wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
			wget https://rpms.remirepo.net/enterprise/remi-release-6.rpm
			rpm -Uvh remi-release-6.rpm epel-release-latest-6.noarch.rpm
			#RepoForge
			case "$arc" in
				32)
				rpm -ivh http://repository.it4i.cz/mirrors/repoforge/redhat/el6/en/i386/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.i686.rpm
				;;
				64)
				rpm -ivh http://repository.it4i.cz/mirrors/repoforge/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
				;;
			esac
		#elrepo
		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		yum install https://www.elrepo.org/elrepo-release-6-8.el6.elrepo.noarch.rpm
        ;;
        7)
		echo "Будут добавлены репозитории EPEL, REMI, RepoForge (бывший RPMForge), ELRepo для CentOS 7"
		wait
		echo "Устанавливаем репозитории..."
		#RepoForge
		rpm -ivh http://repository.it4i.cz/mirrors/repoforge/redhat/el7/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el7.rf.x86_64.rpm
		#epel remi
		wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
		wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm
		rpm -Uvh remi-release-7.rpm epel-release-latest-7.noarch.rpm
		#Elrepo
		rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
		yum install https://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm
        ;;
        *) #сюда мы попали только если при ручном вводе версии RHEL указали несуществующую версию
        echo "Неправильно указана версия RHEL."
        ;;
      esac
}

iptables_save()
{
#проверка CentOS 7
if [ $osver1 -eq 7 ]; then
	myinstall iptables-services | tee > null
fi
service iptables save
}

openport()
{
chain=$(echo $1 | tr [:lower:] [:upper:])
if [ "$chain" == "IN" ]; then chain="INPUT"; t1="dport"
else
	if [ "$chain" == "OUT" ]; then chain="OUTPUT";  t1="sport"
	else
		if [ "$chain" == "FWD" ]; then chain="FORWARD";  t1="sport"
			iptables -I $chain -p $2 --dport $3 -j ACCEPT #дополнительная строка для варианта с FORWARD
		else
			echo "неправильно указано направление правила для открытия порта"
			wait
		fi
	fi
fi
iptables -I $chain -p $2 --$t1 $3 -j ACCEPT #возможно в будущем предусмотрю выбор ключа -I или -A
iptables_save
}

webuzo_install()
{
openport in tcp 2004
openport in tcp 2002
wget http://files.webuzo.com/install.sh -r -N -nd
sh install.sh
rm -f install.sh
}

cwp_install()
{
openport in tcp 2030
openport in tcp 2031
wget http://centos-webpanel.com/cwp-latest
sh cwp-latest
rm -f cwp-latest
}

zpanel_install()
{
wget https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/master/zpanel.sh
sh zpanel.sh
rm -f zpanel.sh
}

ajenti_install()
{
openport in tcp 8000
rpm -i http://repo.ajenti.org/ajenti-repo-1.0-1.noarch.rpm 
echo "Устанавливаем Ajenti"
yum -y install ajenti
echo "Устанавливаем Ajenti V"
yum -y install ajenti-v ajenti-v-nginx ajenti-v-mysql ajenti-v-php-fpm php-mysql
echo "Отключаем SSL для админки"
sed -i -e 's/"enable": true/"enable": false/' /etc/ajenti/config.json
whatismyipext
echo "Выставляем наш внешний IP в конфиг"
sed -i -e "s/\"host\": \"0.0.0.0\"/\"host\": \"$ipext\"/" /etc/ajenti/config.json
echo "Устанавливаем русский язык по умолчанию"
sed -i -e 's/    "bind": {/    "language": "ru_RU",\n    "bind": {/' /etc/ajenti/config.json
echo "Перезапускаем Ajenti"
service ajenti restart
br
echo "Панель управления Ajenti и Ajenti V были установлены. Теперь можете управлять сервером из браузера."
echo "Адрес: http://$ipext:8000"
echo "Логин: root"
echo "Пароль: admin"
br
wait
}

mtu_change()
{
ifconfig $1 mtu $2
}
#Функция проверки установленного приложения, exist возвращает true если установлена и false, если нет.
installed()
{
if [ "$2" == "force" ]; then exist=`rpm -qa $1` #добавили возможности форсированно использовать длинный вариант проверки
else #если нет ключа force, используем старый двойной вариант
	exist=`whereis $1 | awk {'print $2'}` #вариант быстрый, но не всегда эффективный
	if [ -z $exist ]
		then #будем использовать оба варианта
		exist=`rpm -qa $1` #вариант медленнее, но эффективнее
	fi
fi

if [ -n "$exist" ]
then
exist=true
else
exist=false
fi
}

#функция которая открывает на редактирование файл в приоритете: mc, nano, vi
edit()
{
installed mc
if [ $exist == true ]; then mcedit  $1
  else
  installed nano
  if [ $exist == true ]; then nano  $1
    else
    vi $1
  fi
fi
}

#функция удаления.
uninstall()
{
if [ $osver1 -eq 5 ]; then yum erase $1 $2 $3 $4 $5;
else
myinstall yum-remove-with-leaves | tee > null
yum --remove-leaves remove $1 $2 $3 $4 $5
fi
}

#Определяем активный внешний интерфейс
whatismyiface()
{
if [ $osver1 -eq 7 ]; then
  installed net-tools
  if [ $exist == false ]; then yum -y install net-tools | tee > null; fi
fi
if [ -n "$(ifconfig | grep eth0)" ]; then iface="eth0"
else
    if [ -n "$(ifconfig | grep venet0:0)" ]; then iface=venet0:0; fi
fi
}

#определяем ip на внешнем интерфейсе
whatismyip()
{
whatismyiface
case "$osver1" in
4|5|6)
ip=`ifconfig $iface | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
;;
7)
ip=`ifconfig $iface | grep 'inet' | sed q | awk {'print $2'}`
;;
*)
echo "Версия ОС неизвестна. Выходим."
wait
;;
esac
}

#определяем внешний IP через запрос
whatismyipext()
{
installed wget
if [ $exist == false ]; then myinstall wget; fi
ipext=`wget --no-check-certificate -qO- https://2ip.ru/index.php | grep "Ваш IP адрес:" | sed s/.*button\"\>// | sed s_"<"_" "_ | awk {'print $1'}`
}

whatismyip_full()
{
whatismyip
echo "Ваш внешний IP: $ip?"
myread_yn ans
case "$ans" in
  y|Y)
  #ничего не делаем, выходим из case
  ;;
  n|N|т|Т)
  echo "Если был неправильно определен IP, вы можете произвести настройку в ручном режиме."
  echo "Для этого Вам нужно определить как называется Ваш сетевой интерфейс, через который Вы выходите в интернет."
  echo "Если хотите вывести на экран все сетевые интерфейсы, чтобы определить какой из них внешний - нажмите 1."
  myread ans
  if [ "$ans" == "1" ]; then ifconfig; br; wait; fi
  br
  echo "Укажите название интерфейса, который имеет внешний IP (обычно eth0, venet0 или venet0:0)"
  read int
  ip=`ifconfig $int | grep 'inet addr' | awk {'print $2'} | sed s/.*://`
  #centOS7
  if [ $osver1 -eq 7 ]; then ip=`ifconfig $int | grep 'inet' | sed q | awk {'print $2'}`; fi
  echo "Ваш внешний IP: $ip?"
  myread_yn ans
  case "$ans" in
    y|Y)
    ;;
    n|N|т|Т)
    echo "Тогда введите IP вручную:"
    read ip
    ;;
    *)
    echo "Неправильный ответ. Выходим."
    wait
    sh $0
    exit 0
    ;;
  esac
  ;;
  *)
  echo "Неправильный ответ. Выходим."
  wait
  sh $0
  exit 0
  ;;
esac
}

bench_cpu () {
threads=$cpu_cores #делаем кол-во потоков, равное кол-ву ядер
if [ -z $threads ]; then threads=1; fi #если по какой-то причине мы не знаем сколько ядер, ставим в один поток
#if [ -z $cpu_clock ]; then cpu_clock=2394; fi #если по какой-то причине мы не знаем свою частоту, то берем эталонную
totalspeed=$(sysbench cpu --cpu-max-prime=10000 run --num-threads=$threads | grep "events per second:" | awk {'print $4'}) #записали общую скорость
temp=$(echo "${totalspeed/./}") #убрали точку, т.е. умножили на 100.
if [ ${temp:0:1} -eq 0 ]; then temp=$(echo "${temp:1}"); fi #проверили нет ли нуля в начале, если есть - убрали
reference=75000 #скорость на эталонном процессоре, умноженная на 100.
#let "discountpower = $power * 2394 / $cpu_clock" #сколько тестов он бы прошёл при той же частоте, что и эталонный процессор
let "powerpercent = $temp * 1000 / $reference" #мощность этого процессора делим на мощность эталлонного процессора и выражаем в процентах с десятыми долями (но без точки)
powerpercent=$(echo $powerpercent|sed 's/.$/.&/') #добавили точку
#let "discountpowerpercent = $discountpower * 100 / $reference " #мощность этого процессора делим на мощность эталлонного процессора и выражаем в процентах
if [ $threads -gt 1 ]; then #если ядер больше одного, посчитаем еще относительную мощность одного ядра к эталону
let "speedpercore= $temp / $threads" #тут скорость уже умножена на 100
let "powerpercorepercent = $speedpercore * 1000 / $reference " #мощность одного ядра этого процессора к мощности эталонного процессора, выражено в процентах с десятыми долями, но без точки
powerpercorepercent=$(echo $powerpercorepercent|sed 's/.$/.&/') #добавили точку
fi
}


bench_hdd () {
        # Measuring disk speed with DD
        io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Первый прогон: $io"
        io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Второй прогон: $io2"
        io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "   Третий прогон: $io3"
        # Calculating avg I/O (better approach with awk for non int values)
        if [ $(echo $io | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw=$( echo $io | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw=$gb*1024+$mb"
        else ioraw=$( echo $io | awk 'NR==1 {print $1}' )           
        fi

        if [ $(echo $io2 | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw2 |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw2 |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw2=$gb*1024+$mb"
        else ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )           
        fi

        if [ $(echo $io3 | awk '{print $2}') = "GB/s" ] #проверили а не гигабайты ли это
        then #гигабайты
        ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' ) #взяли только число
        gb=$(echo $ioraw3 |  sed 's/\./ /' | awk '{print $1}') #взяли кол-во гигабайт
        mb=$(echo $ioraw3 |  sed 's/\./ /' | awk '{print $2}') #взяли кол-во мегабайт
        if [ ${#mb} -eq 1 ]; then let "mb=$mb*1024/10"; else #переводим десятые доли гигабайт в мегабайты
          if [ ${#mb} -eq 2 ]; then let "mb=$mb*1024/100"; else #переводим сотвые долги гигабайт в мегабайты
            if [ ${#mb} -eq 3 ]; then let "mb=$mb*1024/1000"; else #переводим тысячные долги гигабайт в мегабайты
            mb=0
            fi   
          fi
        fi
        let "ioraw3=$gb*1024+$mb"
        else ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )           
        fi

        ioall=$( awk 'BEGIN{print '$ioraw' + '$ioraw2' + '$ioraw3'}' )
        ioavg=$( awk 'BEGIN{print '$ioall'/3}' )
        
        echo "Среднее значение: $ioavg MB/s"
}


showinfo()
{
echo "$green┌──────────────────────────────────────────────────────────────┐"
echo "│                     Информация о системе                     │"
echo "└──────────────────────────────────────────────────────────────┘"
echo "                            CPU: $cpu_cores x $cpu_clock MHz ($cpu_model)"
if [ $swap_mb -eq 0 ]; then echo "                            RAM: $mem_mb Mb"; else
echo "                            RAM: $mem_mb Mb (Плюс swap $swap_mb Mb)"; fi
#Определяем диск (делаем это при каждом выводе, т.к. данные меняются)
hdd_total=`df | awk '(NR == 2)' | awk '{print $2}'`
let "hdd_total_mb=$hdd_total / 1024"
hdd_free=`df | awk '(NR == 2)' | awk '{print $4}'`
let "hdd_free_mb=$hdd_free / 1024"
#Определяем uptime системы (делаем это при каждом выводе)
uptime=$(uptime | sed -e "s/ * / /g") #сразу берем аптайм без двойных пробелов
uptime=$(echo "${uptime%,* user*}")
uptime=$(echo "${uptime#*up }")
echo "                            HDD: $hdd_total_mb Mb (свободно $hdd_free_mb Mb)"
echo "                             ОС: $osfamily $osver2"
echo "                 Разрядность ОС: $arc bit"
echo "              Версия ядра Linux: $kern"
echo "                 Аптайм системы: $uptime"
if [ ${#iface} -eq 4 ]; then #проверяем какой сетевой интерфейс. Если мы его не определили, то вообще не выводим эту строку
echo "      Ваш IP на интерфейсе $iface: $ip"; fi #длина строки подобрана под eth0
if [ ${#iface} -eq 8 ]; then
echo "  Ваш IP на интерфейсе $iface: $ip"; fi #длина строки подобрана под venet0:0
echo "Ваш внешний IP определяется как: $ipext"
}

about()
{
echo "Данную утилиту написал Павел Евтихов (aka Brizovsky).
г. Екатеринбург, Россия.
2016-2019 год.
"
}
changelog()
{
wget $updpath/changelog.txt -r -N -nd
cat changelog.txt
br
}

log()
{
changelog
}

release() #функция принудительной загрузки релиза
{
wget https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/master/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
sh $0
exit
}

beta() #функция принудительной загрузки Бета-версии
{
wget https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/beta/$filename -r -N -nd --no-check-certificate
chmod 777 $filename
sh $0
exit
}

#-----------------
#задаем переменные
#-----------------
#Задаём переменную с нужным количеством пробелов, чтобы меню не разъезжалось от смены версии
title_full_len=${#title_full}
title_len=${#title}
space=""
      let "space_len=43-$title_full_len" 
      while [ "${#space}" -le $space_len ]
      do
      space=$space" "
      done

space2=""
      let "space2_len=30-$title_len" 
      while [ "${#space2}" -le $space2_len ]
      do
      space2=$space2" "
      done

filename='breeze.sh'
#updpath='https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/master' #релиз
updpath='https://raw.githubusercontent.com/Brizovsky/Breeze-Easy-Shell/beta' #бета

#определяем сколько RAM
mem_total=`cat /proc/meminfo | grep MemTotal | awk '{print $2}'`
swap_total=`cat /proc/meminfo | grep SwapTotal | awk '{print $2}'`
let "mem_mb=$mem_total / 1024"
let "swap_mb=$swap_total / 1024"

#Определяем данные процессора
cpu_clock=`cat /proc/cpuinfo | grep "cpu MHz" | awk {'print $4'} | sed q`
let "cpu_clock=$(printf %.0f $cpu_clock)"
#cpu_cores=`cat /proc/cpuinfo | grep "cpu cores" | awk {'print $4'}`
cpu_cores=`grep -o "processor" <<< "$(cat /proc/cpuinfo)" | wc -l`
cpu_model=`cat /proc/cpuinfo | grep "model name" | sed q | sed -e "s/model name//" | sed -e "s/://" | sed -e 's/^[ \t]*//' | sed -e "s/(tm)/™/g" | sed -e "s/(C)/©/g" | sed -e "s/(R)/®/g"`
#уберём двойные пробелы:
cpu_model=`echo $cpu_model | sed -e "s/ * / /g"`

#Определяем ОС
if [ "$(cat /etc/redhat-release | awk {'print $2'})" == "release" ]
then
  osfamily=$(cat /etc/redhat-release | awk {'print $1'})
  osver2=$(cat /etc/redhat-release | awk {'print $3'})
else
  if [ "$(cat /etc/redhat-release | awk {'print $3'})" == "release" ]
    then
    osfamily=$(cat /etc/redhat-release | awk {'print $1'})" "$(cat /etc/redhat-release | awk {'print $2'})
    osver2=$(cat /etc/redhat-release | awk {'print $4'})
  else osver2=0
  fi
fi
osver1=`echo $osver2 | cut -c 1` #берём только первый символ от версии для определения поколения
if [ "$osfamily" == "CentOS Linux" ]; then osfamily="CentOS"; fi

#Определяем разрядность ОС
arc=`arch`
if [ "$arc" == "x86_64" ]; then arc=64 #В теории возможно обозначение "IA-64" и "AMD64", но я не встречал
else arc=32 #Чтобы не перебирать все возможные IA-32, x86, i686, i586 и т.д.
fi 

#определяем версию ядра Linux
kern=`uname -r | sed -e "s/-/ /" | awk {'print $1'}`

menu="
┌─────────────────────────────────────────────┐
│ $title $ver$space│
├───┬─────────────────────────────────────────┤
│ 1 │ Информация о системе                    │
├───┼─────────────────────────────────────────┤
│ 2 │ Работа с ОС                             │
├───┼─────────────────────────────────────────┤
│ 3 │ Установить панель управления хостингом  │
├───┼─────────────────────────────────────────┤
│ 4 │ Установка и настройка VPN-сервера       │
├───┼─────────────────────────────────────────┤
│ 5 │ Работа с Proxy                          │
├───┼─────────────────────────────────────────┤
│ 6 │ Работа с файлами и программами          │
├───┼─────────────────────────────────────────┤
│ 7 │ Очистка системы                         │
├───┼─────────────────────────────────────────┤
│ 8 │ Терминал                                │
├───┼─────────────────────────────────────────┤
│ 9 │ Обновить $title$space2│
├───┼─────────────────────────────────────────┤
│ 0 │ Выход                                   │
└───┴─────────────────────────────────────────┘
"
menu1="
● Информация о системе:
│
│ ┌───┬──────────────────────────────────────┐
├─┤ 1 │ Показать общую информацию о системе  │
│ ├───┼──────────────────────────────────────┤
├─┤ 2 │ Провести тест скорости CPU           │
│ ├───┼──────────────────────────────────────┤
├─┤ 3 │ Провести тест скорости диска         │
│ ├───┼──────────────────────────────────────┤
├─┤ 4 │ Описание теста производительности    │
│ ├───┼──────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх               │
  └───┴──────────────────────────────────────┘
"
menu2="
● Работа с ОС:
│
│ ┌───┬──────────────────────────────────────┐
├─┤ 1 │ Добавить внешние репозитории         │
│ ├───┼──────────────────────────────────────┤
├─┤ 2 │ Обновить ОС                          │
│ ├───┼──────────────────────────────────────┤
├─┤ 3 │ Установить популярные приложения     │
│ ├───┼──────────────────────────────────────┤
├─┤ 4 │ Антивирус                            │
│ ├───┼──────────────────────────────────────┤
├─┤ 5 │ Firewall (iptables)                  │
│ ├───┼──────────────────────────────────────┤
├─┤ 6 │ Планировщик задач (cron)             │
│ ├───┼──────────────────────────────────────┤
├─┤ 7 │ Установить часовой пояс              │
│ ├───┼──────────────────────────────────────┤
├─┤ 8 │ Сменить пароль текущего пользователя │
│ ├───┼──────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх               │
  └───┴──────────────────────────────────────┘
"
menu24="
● Работа с ОС:
│
└─● Антивирус:
  │
  │ ┌───┬───────────────────────────┐
  ├─┤ 1 │ Установить Антивирус      │
  │ ├───┼───────────────────────────┤
  ├─┤ 2 │ Обновить антивирус        │
  │ ├───┼───────────────────────────┤
  ├─┤ 3 │ Проверить папку на вирусы │
  │ ├───┼───────────────────────────┤
  ├─┤ 4 │ Удалить антивирус         │
  │ ├───┼───────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх    │
    └───┴───────────────────────────┘
"
menu25="
● Работа с ОС:
│
└─● Firewall (iptables):
  │
  │ ┌───┬───────────────────────────────────────────────┐
  ├─┤ 1 │ Включить firewall (помощник настройки)        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 2 │ Отключить firewall (рарешить все подключения) │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 3 │ Временно выключить firewall                   │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 4 │ Перезапустить firewall                        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 5 │ Открыть порт в iptables                       │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 6 │ Закрыть ранее открытый порт в iptables        │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 7 │ Посмотреть текущую политику firewall          │
  │ ├───┼───────────────────────────────────────────────┤
  ├─┤ 8 │ Сохранить текущие правила firewall            │
  │ ├───┼───────────────────────────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх                        │
    └───┴───────────────────────────────────────────────┘
"
menu26="
● Работа с ОС:
│
└─● Планировщик задач (cron):
  │
  │ ┌───┬─────────────────────────────────────────┐
  ├─┤ 1 │ Проверить запущен ли планировщик (cron) │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 2 │ Перезапустить cron                      │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 3 │ Добавить задание в планировщик (cron)   │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 4 │ Открыть файл с заданиями cron           │
  │ ├───┼─────────────────────────────────────────┤
  ├─┤ 5 │ Выключить планировщик (cron)            │
  │ ├───┼─────────────────────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх                  │
    └───┴─────────────────────────────────────────┘
"
menu27="
● Работа с ОС:
│
└─● Установить часовой пояс:
  │
  │ ┌───┬────────────────────────┐
  ├─┤ 1 │ Калининград            │
  │ ├───┼────────────────────────┤
  ├─┤ 2 │ Москва                 │
  │ ├───┼────────────────────────┤
  ├─┤ 3 │ Самара                 │
  │ ├───┼────────────────────────┤
  ├─┤ 4 │ Екатеринбург           │
  │ ├───┼────────────────────────┤
  ├─┤ 5 │ Новосибирск            │
  │ ├───┼────────────────────────┤
  ├─┤ 6 │ Красноярск             │
  │ ├───┼────────────────────────┤
  ├─┤ 7 │ Иркутск                │
  │ ├───┼────────────────────────┤
  ├─┤ 8 │ Владивосток            │
  │ ├───┼────────────────────────┤
  ├─┤ 9 │ Камчатка               │
  │ ├───┼────────────────────────┤
  └─┤ 0 │ Выйти на уровень вверх │
    └───┴────────────────────────┘
"
menu3="
● Установить панель управления хостингом:
│
│ ┌───┬────────────────────────┐
├─┤ 1 │ ISPmanager 4           │
│ ├───┼────────────────────────┤
├─┤ 2 │ ISPmanager 5           │
│ ├───┼────────────────────────┤
├─┤ 3 │ Brainy CP              │
│ ├───┼────────────────────────┤
├─┤ 4 │ Vesta CP               │
│ ├───┼────────────────────────┤
├─┤ 5 │ Webuzo                 │
│ ├───┼────────────────────────┤
├─┤ 6 │ CentOS Web Panel (CWP) │
│ ├───┼────────────────────────┤
├─┤ 7 │ ZPanel CP              │
│ ├───┼────────────────────────┤
├─┤ 8 │ Ajenti                 │
│ ├───┼────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх │
  └───┴────────────────────────┘
"
menu4="
● Установка и настройка VPN-сервера:
│
│ ┌───┬────────────────────────────────────────────────┐
├─┤ 1 │ Установить VPN-сервер (pptpd)                  │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 2 │ Добавить пользователей VPN                     │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 3 │ Открыть файл с логинами/паролями пользователей │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 4 │ Добавить правила для работы VPN в IPTables     │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 5 │ Удалить VPN-сервер                             │
│ ├───┼────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                         │
  └───┴────────────────────────────────────────────────┘
"
menu5="
● Работа с Proxy:
│
│ ┌───┬────────────────────────────────────────────────┐
├─┤ 1 │ Установить Proxy-сервер (на базе Squid)        │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 2 │ Удалить Proxy (Squid)                          │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 3 │ Поменять MTU для интерфейса                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 4 │ Открыть файл настроек Squid                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 5 │ Добавить пользователя Proxy                    │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 6 │ Открыть файл с логинами/паролями пользователей │
│ ├───┼────────────────────────────────────────────────┤
├─┤ 7 │ Перезапустить сервис Proxy (Squid)             │
│ ├───┼────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                         │
  └───┴────────────────────────────────────────────────┘
"
menu6="
● Работа с файлами и программами:
│
│ ┌───┬─────────────────────────────────────────────────────┐
├─┤ 1 │ Установить какую-либо программу                     │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 2 │ Удалить какую-либо программу                        │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 3 │ Удалить какую-либо программу со всеми зависимостями │
│ ├───┼─────────────────────────────────────────────────────┤
├─┤ 4 │ Посмотреть сколько свободного места на диске        │
│ ├───┼─────────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                              │
  └───┴─────────────────────────────────────────────────────┘
"
menu7="
● Очистка системы:
│
│ ┌───┬─────────────────────────────────────────────────┐
├─┤ 1 │ Удалить старые установочные пакеты (кэш yum)    │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 2 │ Удалить логи Apache, Nginx, Squid и прочие логи │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 3 │ Удалить логи Apache конкретного пользователя    │
│ ├───┼─────────────────────────────────────────────────┤
├─┤ 4 │ Посмотреть сколько свободного места на диске    │
│ ├───┼─────────────────────────────────────────────────┤
└─┤ 0 │ Выйти на уровень вверх                          │
  └───┴─────────────────────────────────────────────────┘
"

#-----------------
#Интерфейс
#-----------------
repeat=true
chosen=0
chosen2=0
while [ "$repeat" = "true" ] #выводим меню, пока не надо выйти
do

#пошёл вывод
if [ $chosen -eq 0 ]; then #выводим меню, только если ещё никуда не заходили
menu
myread_dig pick
else
pick=$chosen
fi

case "$pick" in
1) #Информация о системе
chosen=1
clear
echo "$title"
echo "$menu1"
myread_dig pick
    case "$pick" in
    1) #Показать общую информацию о системе
		clear
		showinfo
		br
		echo "Вычисляем Ваш IP на интерфейсе..."
		whatismyip
		clear
		showinfo
		br
		echo "Вычисляем Ваш внешний IP..."
		whatismyipext
		clear
		showinfo
		br
		wait
    ;;
    2) #Провести тест скорости CPU
		clear
		installed sysbench
		if [ $exist == false ]; then
			echo "Сейчас будет произведена установка программы sysbench. Но для её установки нужно наличие добавленного репозитория EPEL."
			echo "Если вы уже добавляли репозитории сами или с помощью этой программы, то от вас ничего не требуется. В противном случае, их нужно добавить."
			echo "Добавить репозитории?"
			myread_yn pick
			case "$pick" in
				y|Y)
				repo
				echo "Установка репозиториев завершена."
				;;
			esac
			myinstall sysbench
		fi
		clear
		echo "Сейчас будет произведен тест скорости процессора. Ждите..."
		bench_cpu
		br
		echo "Ваш процессор выполнил $totalspeed вычислений в секунду. Количество используемых потоков: $threads"
		echo "Мощность вашего процессора соответствует $powerpercent% от эталонного одноядерного процессора."
		if [ $cpu_cores -gt 1 ]; then echo "В пересчете на одно ядро мощность вашего процессора составляет $powerpercorepercent% от эталонного."; fi #пересчет на 1 ядро выводим только если ядер больше одного
		br
		wait
    ;;
    3) #Провести тест скорости диска
		clear
		echo "Сейчас будет произведен тест скорости диска. Ждите..."
		br
		bench_hdd
		br
		echo "Тест завершен."
		br
		wait
    ;;
    4) #Описание теста производительности
		clear
		echo "Для теста производительности процессора используется утилита sysbench."
		echo "В ней используется 10000 проходов. Количество потоков устанавливается равным"
		echo "количеству ядер вашего процессора (если не удалось определить количество ядер,"
		echo "используется однопоточный режим), а конечный результат сравнивается с эталонным"
		echo "процессором. За эталонный процессор были взяты виртуальные ядра хостеров Vultr и"
		echo "Digital Ocean, работающие на частоте 2,4 Ghz"
		br
		echo "Для теста скорости диска мы пытаемся записать на диск кусок в 64Кб 16 тысяч раз"
		echo "(общий объём данных 1000 Мб). Тест прогоняем трижды, показываем каждый результат"
		echo "по отдельности, а также среднее значение. Заодно вы сможете оценить насколько"
		echo "сильно \"плавает\" это значение от одного прохода к другому."
		br
		wait
    ;;
    0)
     chosen=0
    ;;
    esac
;;
2) #Работа с ОС
chosen=2
clear
if [ $chosen2 -eq 0 ]; then #выводим меню, только если ещё никуда не заходили
echo "$title"
echo "$menu2"
myread_dig pick
else
pick=$chosen2
fi
    case "$pick" in
    1) #Добавить внешние репозитории
      repo
	  br
	  echo "Установка репозиториев завершена."
	  br
	  wait
	;;
    2) #Обновить ОС
    echo "Начинаем обновление ОС..."
    yum update -y
    echo "ОС была успешно обновлена."
    wait    
    ;;
    3) #Установить популярные приложения
    echo "Сечас будут установлены следующие программы:"
    echo "mc - Midnigh Commander (файловый менеджер)"
    echo "htop (более продвинутый мониторинг ресурсов)"
    echo "nano (простейший текстовый редактор)"
    if [ $osver1 -ne 5 ]; then echo "аддон для yum, который позволяет удалять программы со всеми зависимостями"; fi #Не для CentOS 5
    if [ $osver1 -eq 7 ]; then echo "net-tools (чтобы вернуть команду ifconfig)"; fi #Только для CentOS 7
    br
    wait
    echo "Начинаем установку программ..."
    yum -y install mc
    yum -y install htop
    yum -y install nano
    if [ $osver1 -ne 5 ]; then yum -y install yum-remove-with-leaves; fi #Не для CentOS 5
    if [ $osver1 -eq 7 ]; then yum -y install net-tools; fi #Только для CentOS 7
    br
    echo "Программы были установлены."
    wait    
    ;;
    4) #Антивирус
    chosen2=4
    clear
    echo "$title"
    echo "$menu24"
    myread_dig pick
    case "$pick" in
      1) #Установить Антивирус
      echo "сейчас будет установлен антивирус ClamAV."
      wait
      yum -y install clamav clamd
      br
      echo "Антивирус был установлен. Сейчас обновим антивирусные базы"
      br
      freshclam
      br
      echo "Базы были обновлены."
      br
      echo "Сейчас мы попробуем запустить этот сервис (демон)."
      chkconfig --levels 235 clamd on
      service clamd restart
      br
      echo "Всё готово!"
      wait
      ;;
      2) #Обновить антивирус
      installed clamscan
      if [ $exist == true ]; then
        freshclam
        br
        wait
      else
        echo "У вас не установлен антивирус."
      wait
      fi
      ;;
      3) #Проверить папку на вирусы
      installed clamscan
      if [ $exist == true ]; then
        echo 'Укажите папку, которую нужно просканировать (введите "/", если весь сервер):'
        read scandir
        echo "Нужно ли сохранить лог сканирования в файл?"
        myread_yn avlog
        case "$avlog" in
         y|Y)
           echo 'Укажите путь для сохранения лога сканирования (начиная с "/")'
           read avlogdir
           echo "Сканируем..."
           br
           clamscan $scandir -r -i --log=$avlogdir
         ;;
         n|N|т|Т)
         echo "Сканируем..."
         br
         clamscan $scandir -r
         ;;
         *)
         echo "Неправильный выбор"
         wait
         ;;
        esac
      br
      wait
      else
        echo "У вас не установлен антивирус."
        wait
      fi
      ;;
      4) #Удалить антивирус
      uninstall clamav*
      br
      wait
      ;;
      0)
      chosen2=0
      ;;
    esac
    ;;
    5) #Firewall (iptables)
    chosen2=5
    clear
    echo "$title"
    echo "$menu25"
    myread_dig pick
    case "$pick" in
      1) #Включить firewall (помощник настройки)
      clear
      echo "Сейчас будут удалены все правила iptables (если они были), установлен запрет"
      echo "на обработку всех входящих и исходящих пакетов, кроме внутреннего обмена"
      echo "пакетами (localhost), SSH-подключения (22 порт) и всех связанных пакетов"
      echo "(состояние RELATED и ESTABLISHED). А далее вам будет предложен вариант открыть"
      echo "самые распространенные порты (с вашего разрешения). Продолжить?"
      myread_yn ans
      case "$ans" in
        y|Y)
        echo "Начинаем настройку iptables"
		#Проверка на CentOS 7
        if [ $osver1 -eq 7 ]; then 
        systemctl stop firewalld
		systemctl mask firewalld
		myinstall iptables-services | tee > null
		systemctl enable iptables
        fi
        iptables -F
        iptables -X
        iptables -A INPUT -i lo -j ACCEPT
        iptables -A OUTPUT -o lo -j ACCEPT
        iptables -A INPUT -p tcp --dport 22 -j ACCEPT
        iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
        iptables -P INPUT DROP
        iptables -P OUTPUT DROP
        iptables -P FORWARD DROP
        iptables -A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
        iptables -A OUTPUT -m state --state NEW,RELATED,ESTABLISHED -j ACCEPT
        br
        echo "Готово. Хотите, чтобы этот компьютер пинговался с других компьютеров?"
        myread_yn ans
        case "$ans" in
          y|Y)
          iptables -A INPUT -p icmp --icmp-type 0 -j ACCEPT
          iptables -A INPUT -p icmp --icmp-type 8 -j ACCEPT
          iptables -A OUTPUT -p icmp -j ACCEPT
          ;;
        esac
        br
        echo "Часто люди на серверах открывают следующие порты:"
        echo "web: 80, 443"
        echo "ftp: 21"
        echo "ntp: 123 (для синхронизации часов)"
        echo "dns: 54"
        echo "Хотите открыть их сейчас?"
        myread_yn ans
        case "$ans" in
          y|Y)
          iptables -A INPUT -p tcp --dport 21 -j ACCEPT
          iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
          iptables -A OUTPUT -p tcp --sport 21 -j ACCEPT
          iptables -A INPUT -p tcp --dport 80 -j ACCEPT
          iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
          iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
          iptables -A INPUT -p tcp --dport 443 -j ACCEPT
          iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
          iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT
          iptables -A OUTPUT -p udp --dport 53 -m state --state NEW -j ACCEPT
          iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
          ;;
        esac
        br
        echo "Хотите открыть порт 3128 для Proxy?"
        myread_yn ans
        case "$ans" in
          y|Y)
          iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
          ;;
        esac
        br
        echo "Хотите открыть порты для VPN-сервера (PPTP)?"
        myread_yn ans
        case "$ans" in
          y|Y)
          whatismyip_full
          iptables -A INPUT -p 47 -j ACCEPT
          iptables -A OUTPUT -p 47 -j ACCEPT
          iptables -A INPUT -p tcp --dport 1723 -j ACCEPT
          iptables -A OUTPUT -p tcp --sport 1723 -j ACCEPT
          iptables -t nat -I POSTROUTING -j SNAT --to $ip
          iptables -A FORWARD -s 10.1.0.0/24 -j ACCEPT
          iptables -A FORWARD -d 10.1.0.0/24 -j ACCEPT
          ;;
        esac
        iptables_save
        br
        echo "Firewall был настроен. Остальные порты вы можете открыть самостоятельно,"
        echo 'воспользовавшись разделом "Открыть порт в iptables".'
        wait
        ;;
      esac
      ;;
      2) #Выключить firewall (рарешить все подключения)
	  echo "Сейчас будут удалены все правила iptables, после чего будут разрешены все подключения. Продолжить?"
      myread_yn ans
      case "$ans" in
        y|Y)
        iptables -F
        iptables -X
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -P OUTPUT ACCEPT
        ;;
      esac
      iptables_save
      br
      echo "Готово. Iptables продолжает работать, но в нём разрешены все подключения."
      wait
      ;;
      3) #Временно выключить firewall
      iptables -F
      iptables -X
      iptables -P INPUT ACCEPT
      iptables -P FORWARD ACCEPT
      iptables -P OUTPUT ACCEPT
      br
      echo "Готово. Были временно сброшены все правила для iptables. Сейчас проходят все"
      echo "подключения. После перезагрузки сервера или перезапуска iptables всё будет"
      echo "как прежде (применятся все правила, которые были до этого)."
      br
      wait
      ;;
      4) #Перезапустить firewall
      if [ $osver1 -eq 7 ]; then 
	  myinstall iptables-services | tee > null
      fi
      service iptables restart
      br
      echo "Готово. "
      wait
      ;;
      5) #Открыть порт в iptables
      echo "Укажите в какую сторону вы хотите открыть порт:"
      echo "1) Входящие соединения (чтобы к этому серверу можно было подключиться по заданному порту)"
      echo "2) Исходящие соединения (чтобы этот сервер мог подключиться к другим компьютерам по заданному порту)"
      echo "3) Перенаправление пакетов (раздел FORWARD)"
      myread_dig taffic_type
      case "$taffic_type" in
      1)
      taffic_type=in
      ;;
      2)
      taffic_type=out
      ;;
	  3)
      taffic_type=fwd
      ;;      
      *)
      echo "Неправильный выбор. Аварийный выход."
      wait
      exit
      ;;
      esac
      br
      echo "Укажите какой порт вы хотите открыть:"
      read port
      br
      echo "Выберите протокол, по которому его нужно открыть:"
      echo "1) TCP"
      echo "2) UDP"
      echo "3) TCP и UDP"
      myread_dig protocol
      case "$protocol" in
		1)
		openport $taffic_type tcp $port
		;;
		2)
		openport $taffic_type udp $port
		;;
		3)
		openport $taffic_type tcp $port
		openport $taffic_type udp $port
		;;
		*)
		echo "Неправильный выбор."
		;;
      esac
      br
      echo "Готово."
      wait
      ;;
      6) #Закрыть ранее открытый порт в iptables
	  br
	  iptables --list --line-numbers
	  br
	  echo "Из какого раздела вы хотите удалить правило?"
      echo "1) Входящие соединения (раздел INPUT)"
      echo "2) Исходящие соединения (раздел OUTPUT)"
      echo "3) Перенаправление пакетов (раздел FORWARD)"
      myread_dig section
      case "$section" in
      	1)
      	section=INPUT
      	;;
      	2)
      	section=OUTPUT
      	;;
	  	3)
      	section=FORWARD
      	;;      
      	*)
      	echo "Неправильный выбор. Аварийный выход."
      	wait
      	exit
      	;;
      esac
      echo "Правило под каким номером нужно удалить?"
      myread_dig rule_number
      iptables -D $section $rule_number
	  iptables_save
	  br
      echo "Правило удалено"
	  wait
	  ;;
      7) #Посмотреть текущую политику firewall
      iptables -nvL
      br
      wait
      ;;
      8) #Сохранить текущие правила firewall
      iptables_save
      br
      echo "Готово."
      wait
      ;;
      0)
      chosen2=0
      ;;
    esac
    ;;
    6) #Планировщик задач (cron)
    chosen2=6
    clear
    echo "$title"
    echo "$menu26"
	myread_dig pick
    case "$pick" in
		1) #Проверить запущен ли планировщик (cron)
		installed crond
		if [ $exist == false ]; then 
			echo "Сервис Cron не установлен. Установить?"
			myread_yn pick
			case "$pick" in
				y|Y)
					case "$osver1" in
						4|5|6)
							myinstall vixie-cron crontabs
						;;
						7)
							myinstall cronie
						;;
					esac
				br
				echo "Установка завершена, продолжаем работу..."
				wait
				clear
				;;
			esac
		fi
		if [[ -n $(service crond status | grep "is running") ]]; then
			echo "Планировщик Cron работает..."
			wait
		else
			echo "Планировщик Cron в данный момент не запущен. Попробовать запустить?"
			myread_yn pick
			case "$pick" in
				y|Y)
				service crond start
				br
				echo "Готово. Хотите добавить Cron в автозагрузку, чтобы он запускался после каждой перезагрузки?"
				myread_yn pick
				case "$pick" in
					y|Y)
					echo "Добавляем..."
					chkconfig crond on
					echo "Готово."
					br
					wait
					;;
				esac	
				;;
			esac
		fi
		;;
		2) #Перезапустить cron
		service crond restart
		br
		wait
		;;
		3) #Добавить задание в планировщик (cron)
		clear
		echo "Введите команду, которую должен выполнять планировщик:"
		read cron_task
		br
		echo "Выберите интервал, с которым должна выполняться эта задача:"
		echo "1) При каждой загрузке системы"
		echo "2) Один или несколько раз в час"
		echo "3) Один или несколько раз в день"
		echo "4) Один раз в неделю"
		echo "5) Один раз в месяц"
		echo "0) Не нужно выполнять, я передумал"
		myread_dig pick
		case "$pick" in
			1)
			echo "@reboot $cron_task" >> /var/spool/cron/$(whoami)
			echo "Готово. Задание будет выполняться после каждой загрузки системы."
			;;
			2)
			br
			echo "Выберите интервал"
			echo "1) Каждый час"
			echo "2) Два раза в час (каждые 30 минут)"
			echo "3) Три раза в час (каждые 20 минут)"
			echo "4) Четыре раза в час (каждые 15 минут)"
			echo "5) Шесть раз в час (каждые 10 минут)"
			echo "6) Двенадцать раз в час (каждые 5 минут)"
			echo "7) Тридцать раз в час (каждые 2 минуты)"
			echo "8) Шестьдесят раз в час (каждую минуту)"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1)
				echo "0 * * * * $cron_task" >> /var/spool/cron/$(whoami) # @hourly
				echo "Готово. Задание будет выполняться в 0 минут каждого часа."
				;;
				2)
				echo "*/30 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 30 минут"					
				;;
				3)
				echo "*/20 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 20 минут"				
				;;
				4)
				echo "*/15 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 15 минут"				
				;;
				5)
				echo "*/10 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 10 минут"				
				;;
				6)
				echo "*/5 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 5 минут"				
				;;
				7)
				echo "*/2 * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 2 минуты"				
				;;
				8)
				echo "* * * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждую минуту"				
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;				
			esac
			;;
			3)
			br
			echo "Выберите интервал"
			echo "1) Каждый день (можно выбрать в какой час)"
			echo "2) Два раза в день (каждые 12 часов)"
			echo "3) Три раза в день (каждые 8 часов)"
			echo "4) Четыре раза в день (каждые 6 часов)"
			echo "5) Шесть раз в день (каждые 4 часа)"
			echo "6) Двенадцать раз в день (каждые 2 часа)"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1)
				br
				echo "Укажите в какой час запускать задание (0-23)"
				read temp
				let temp2=$temp+0
				if [[ $temp2 -gt 0 && $temp2 -le 23 ]]; then #введён правильно
					echo "0 $temp * * * $cron_task" >> /var/spool/cron/$(whoami)
					echo "Готово. Задание будет выполняться каждый $temp-й час"
				else #возможно введён неправильно
					if [[ "$temp" = "0" ]]; then #всё-таки введён правильно
						echo "0 $temp * * * $cron_task" >> /var/spool/cron/$(whoami)
						echo "Готово. Задание будет выполняться каждый $temp-й час"
					else #точно введён неправильно
						echo "Неправильно указали час"
					fi
				fi
				;;
				2)
				echo "0 */12 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 12 часов"					
				;;
				3)
				echo "0 */8 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 8 часов"					
				;;
				4)
				echo "0 */6 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 6 часов"					
				;;
				5)
				echo "0 */4 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 4 часа"					
				;;
				6)
				echo "0 */2 * * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждые 2 часа"					
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;	
			esac
			;;
			4)
			br
			echo "Выберите день недели, в который надо запускать задание"
			echo "1) Понедельник"
			echo "2) Вторник"
			echo "3) Среда"
			echo "4) Четверг"
			echo "5) Пятница"
			echo "6) Суббота"
			echo "7) Воскресенье"
			echo "0) Не нужно выполнять, я передумал"
			myread_dig pick
			case "$pick" in
				1|2|3|4|5|6|7)
				echo "0 4 * * $pick $cron_task" >> /var/spool/cron/$(whoami)
				case "$pick" in
					1) day="каждый понедельник"
					;;
					2) day="каждый вторник"
					;;
					3) day="каждую среду"
					;;
					4) day="каждый четверг"
					;;
					5) day="каждую пятницу"
					;;
					6) day="каждую субботу"
					;;
					7) day="каждое воскресенье"
					;;
				esac
				echo "Готово. Задание будет выполняться $day в 4 часа утра."
				;;
				0)
				;;
				*)
				echo "Неправильный выбор..."
				;;
			esac
			;;
			5)
			br
			echo "Укажите в какой день месяца запускать задание"
			read temp
			let temp=$temp+0
			if [[ $temp -gt 0 && $temp -le 31 ]]; then #введён правильно
				echo "0 4 $temp * * $cron_task" >> /var/spool/cron/$(whoami)
				echo "Готово. Задание будет выполняться каждое $temp-ое часло каждого месяца в 4 часа утра."
			else # введён неправильно
				echo "Неправильно выбрано число"
			fi
			;;
			0)
			;;
			*)
			echo "Неправильный выбор..."
			;;
		esac
		service crond reload  | tee > null
		br
		wait
		;;
		4) #Открыть файл с заданиями cron
		edit /var/spool/cron/$(whoami)
		;;
		5) #Выключить планировщик (cron)
		echo "Планировщик не рекомендуется отключать. Вы уверены что хотите отключить его?"
		myread_yn pick
		case "$pick" in
			y|Y)
			br
			service crond stop
			br
			echo "Планировщик был выключен. Если он стоял в автозагрузке, то он вновь будет запущен после перезагрузки системы"
			br
			wait
			;;
		esac
		;;
		0) #Выйти на уровень вверх
		chosen2=0
		;;
	esac	
    ;;
    7) #Установить часовой пояс
    clear
    echo "$title"
    echo "$menu27"
    echo "Текущее время на этом компьютере: $(date +%H:%M). Выберите часовой пояс, который хотите установить."
    myread_dig pick
        case "$pick" in
        1)
        settimezone Europe Kaliningrad
        ;;
        2)
        settimezone Europe Moscow
        ;;
        3)
        settimezone Europe Samara
        ;;
        4)
        settimezone Asia Yekaterinburg
        ;;
        5)
        settimezone Asia Novosibirsk
        ;;
        6)
        settimezone Asia Krasnoyarsk
        ;;
        7)
        settimezone Asia Irkutsk
        ;;
        8)
        settimezone Asia Vladivostok
        ;;
        9)
        settimezone Asia Kamchatka
        ;;
        0)
        ;;
        *)
        echo "Неправильный выбор."
        wait
        esac
    ;;
    8) #Сменить пароль текущего пользователя
    passwd
    br
    wait
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
3) #Установить панель управления хостингом
chosen=3
clear
echo "$title"
echo "$menu3"
myread_dig pick
    case "$pick" in
    1) #ISPmanager 4
    clear
    echo 'Панель управления "ISPManager 4"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления ПЛАТНАЯ! Без лицензии, активированной на ваш IP даже не установится.'
    echo 'Язык: Русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
        wget "http://download.ispsystem.com/install.4.sh" -r -N -nd
        sh install.4.sh
        wait
        rm -f install.4.sh
      ;;
    esac
    ;;
    2) #ISPmanager 5
    clear
    echo 'Панель управления "ISPManager 5"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления ПЛАТНАЯ! После установки будет Trial на 14 дней.'
    echo 'Язык: Русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
        wget http://cdn.ispsystem.com/install.sh -r -N -nd
        sh install.sh
        rm -f install.sh
      ;;
    esac
    ;;
    3) #Brainy CP
    clear
    echo 'Панель управления "Brainy"'
    echo 'Поддержка ОС: CentOS 7 64bit (и только эта ОС!)'
    echo 'Системные требования (минимальные): 512 Mb RAM + 1Gb SWAP, HDD 2 Gb в корневом разделе'
    echo 'Системные требования (рекомендованные): 2 Gb RAM + 2Gb SWAP, HDD 3 Gb в корневом разделе'
    echo 'Лицензия: Панель абсолютно бесплатная'
    echo 'Язык: Русский, Английский, Польский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
	  yum clean all && yum install -y wget && wget http://core.brainycp.com/install.sh && bash ./install.sh
      ;;
    esac
    ;;
    4) #Vesta CP
    clear
    echo 'Панель управления "Vesta CP"'
    echo 'Поддержка ОС: CentOS | RHEL | Debian | Ubuntu'
    echo 'Системные требования: минимальные не определены'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский, русский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      if [[ $(pidof httpd) != "" ]] #проверяем установлен ли httpd
      then
        echo "У вас установлен http-сервер, а Vesta CP требует установки на чистую машину."
        echo 'Хотите удалить его перед установкой "Vesta CP"?'
        myread_yn pick
        case "$pick" in
          y|Y)
          service httpd stop
          yum erase httpd -y
          ;;
        esac
      fi
      br
      echo 'Начинаем установку...'
      openport in tcp 8083
      wget http://vestacp.com/pub/vst-install.sh -r -N -nd
      sh vst-install.sh --force
      rm -f vst-install.sh
      ;;
    esac
    ;;
    5) #Webuzo
    clear
    echo 'Панель управления "Webuzo"'
    echo 'Поддержка ОС: CentOS 5.x, 6.x | RHEL 5.x, 6.x | Scientific Linux 5.x, 6.x | Ubuntu LTS'
    echo 'Системные требования: 512 Mb RAM (minimum)'
    echo 'Лицензия: Панель управления имеет платную и бесплатную версию. Установите без лицензии для использования бесплатной версии.'
    echo 'Язык: Английский'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|6)
        webuzo_install
        ;;
        7)
        echo 'У вас CentOS 7.x. Данная панель управления не поддерживает эту версию. Выходим.'
        wait
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          webuzo_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    6) #CentOS Web Panel (CWP)
    clear
    echo 'Панель управления "CentOS Web Panel (CWP)"'
    echo 'Поддержка ОС: CentOS 6.x | RHEL 6.x | CloudLinux 6.x'
    echo 'Системные требования: 512 MB RAM (minimum)'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский'
    br
    echo "ВНИМАНИЕ! Данная панель будет устанавливаться очень долго (до 1 часа)!"
    br
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|7)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6)
        cwp_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          cwp_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    7) #ZPanel CP
    clear
    echo 'Панель управления "ZPanel CP"'
    echo 'Поддержка ОС: CentOS 6.x | RHEL 6.x'
    echo 'Системные требования: не указаны разработчиком'
    echo 'Лицензия: Панель управления полностью бесплатна.'
    echo 'Язык: Английский, немецкий'
    br
    echo 'ВНИМАНИЕ! Поддержка данной панели давно прекращена, русификации нет. Устанавливайте на свой страх и риск.'
    br
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        5|7)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6)
        zpanel_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          zpanel_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    8) #Ajenti
    clear
    echo 'Панель управления "Ajenti"'
    echo 'Поддержка ОС: CentOS 6, 7 | Debian 6, 7, 8 | Ubuntu | Gentoo'
    echo 'Системные требования: 35 Mb RAM '
    echo 'Лицензия: Панель имеет как бесплатную версию, так и платную'
    echo 'Описание: Ajenti - это панель управления сервером, но к ней есть Addon под названием Ajenti V,'
    echo '          с помощью которого можно управлять хостингом.'
    echo 'Язык: Английский, русский и ещё 42 других языка'
    echo 'Хотите установить?'
    myread_yn pick
    case "$pick" in
      y|Y)
      case "$osver1" in
        4|5)
        echo "У вас CentOS $osver1.x. Данная панель управления не поддерживает эту версию. Выходим."
        wait
        ;;
        6|7)
        ajenti_install
        ;;
        0)
        echo 'нам не удалось определить Вашу ОС. Возможно, она не поддерживается Webuzo.'
        echo 'Хотите всё равно установить данную панель управления на свой страх и риск?'
        myread_yn ans
        case "$ans" in
          y|Y)
          ajenti_install
          ;;
          n|N|т|Т)
          ;;
          *)
          echo 'Неправильный выбор. Выходим.'
          wait
          ;;
        esac
        ;; 
      esac
      ;;
      n|N|т|Т)
      ;;
      *)
      echo 'Неправильный выбор. Выходим.'
      wait
      ;;
    esac
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор."
    wait
    ;;
    esac
;;
4) #Установка и настройка VPN-сервера
chosen=4
clear
echo "$title"
echo "$menu4"
myread_dig pick
    case "$pick" in
    1) #Установить VPN-сервер (pptpd)
        echo "Внимание! Данный скрипт работает ТОЛЬКО на centOS!"
        echo "Внимание! Для работы VPN нужен интерфейс PPP, который обычно отключен при виртуализации"
        echo "на OpenVZ. Его можно включить через тех.поддержку или в панели управления сервером."
        echo "Если у вас технология виртуализации XEN или KVM, то всё нормально."
        br
        echo "Далее будет произведено обновление ОС и установка нужных компонентов для VPN-сервера."
        wait
        br
        echo "установка PPTP"
        #CentOS 5
        if [ $osver1 -eq 5 ]; then rpm -Uvh http://pptpclient.sourceforge.net/yum/stable/rhel5/pptp-release-current.noarch.rpm; fi
        #yum update -y
        yum -y install ppp pptpd pptp
        br
        whatismyip_full
          #открываем порты и настраиваем маршрутизацию
          br
          echo "Открываем порты в firewall для работы VPN"
          br
            iptables -I INPUT -p 47 -j ACCEPT
            iptables -I OUTPUT -p 47 -j ACCEPT
			openport in tcp 1723
			openport out tcp 1723
            iptables -t nat -I POSTROUTING -j SNAT --to $ip
            iptables -I FORWARD -s 10.1.0.0/24 -j ACCEPT
            iptables -I FORWARD -d 10.1.0.0/24 -j ACCEPT
          #теперь делаем так, чтобы сохранились правила после перезагрузки
          iptables_save
          br
          echo "Введите имя пользователя, которое нужно создать (н.п.. client1 or john):"
          read u
          echo "Введите пароль для этого пользователя:"
          read p
          br
          echo "Создание конфигурации сервера"
          cat > /etc/ppp/pptpd-options <<END
name pptpd
refuse-pap
refuse-chap
refuse-mschap
require-mschap-v2
require-mppe-128
ms-dns 8.8.8.8
ms-dns 8.8.4.4
proxyarp
nodefaultroute
lock
nobsdcomp
END
          sed -i -e '/net.ipv4.ip_forward = 0/d' /etc/sysctl.conf #Удаляем строчку net.ipv4.ip_forward = 0
          echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
          sysctl -p
          # setting up pptpd.conf
          echo "option /etc/ppp/pptpd-options" > /etc/pptpd.conf
          echo "logwtmp" >> /etc/pptpd.conf
          echo "localip $ip" >> /etc/pptpd.conf
          echo "remoteip 10.1.0.1-100" >> /etc/pptpd.conf
          #autostart pptpd
          chkconfig pptpd on          
          # adding new user
          echo "$u * $p *" >> /etc/ppp/chap-secrets
          # правим mtu для 10 ppp-юзеров
          sed -i -e '/exit 0/d' /etc/ppp/ip-up #Удаляем exit 0 в конце файла
          cat >> /etc/ppp/ip-up <<END
ifconfig ppp0 mtu 1400
ifconfig ppp1 mtu 1400
ifconfig ppp2 mtu 1400
ifconfig ppp3 mtu 1400
ifconfig ppp4 mtu 1400
ifconfig ppp5 mtu 1400
ifconfig ppp6 mtu 1400
ifconfig ppp7 mtu 1400
ifconfig ppp8 mtu 1400
ifconfig ppp9 mtu 1400
exit 0 #возвращаем exit 0
END
          br
          echo "Перезапуск PPTP"
          service pptpd restart
          #centOS7
          if [ $osver1 -eq 7 ]; then systemctl start pptpd; systemctl enable pptpd.service; fi
          br
          echo "Настройка вашего собственного VPN завершена!"
          echo "Ваш IP: $ip? логин и пароль:"
          echo "Имя пользователя (логин):$u ##### Пароль: $p"
          br
          wait
    ;;
    2) #Добавить пользователей VPN
    echo "Введите имя пользователя для создания (eg. client1 or john):"
    read u
    echo "введите пароль для создаваемого пользователя:"
    read p
    # adding new user
    echo "$u * $p *" >> /etc/ppp/chap-secrets
    echo
    echo "Дополнительный пользователь создан!"
    echo "Имя пользователя (логин):$u ##### Пароль: $p"
    br
    wait
    ;;
    3) #Открыть файл с логинами/паролями пользователей
    edit /etc/ppp/chap-secrets
    ;;
    4) #Добавить правила для работы VPN в IPTables
    whatismyip_full    
    iptables -I INPUT -p 47 -j ACCEPT
    iptables -I OUTPUT -p 47 -j ACCEPT
	openport in tcp 1723
	openport out tcp 1723
    iptables -t nat -I POSTROUTING -j SNAT --to $ip
    iptables -I FORWARD -s 10.1.0.0/24 -j ACCEPT
    iptables -I FORWARD -d 10.1.0.0/24 -j ACCEPT
    br
    echo 'Хотите, чтобы это правило сохранялось после перезагрузки?'
    myread_yn ans
    case "$ans" in
      y|Y)
      iptables_save  
      ;;
    esac
    br
    wait
    ;;
    5) #Удалить VPN-сервер
    clear
    echo "Внимание! Будет полностью удален VPN-сервер, файл с логинами/паролями и файл настроек"
    echo "Продолжить?"
    myread_yn ans
    case "$ans" in
    y|Y)
    uninstall -y pptpd pptp
    rm -f /etc/ppp/chap-secrets
    rm -f /etc/pptpd.conf
    sed -i -e '/ifconfig ppp0 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp1 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp2 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp3 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp4 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp5 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp6 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp7 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp8 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
    sed -i -e '/ifconfig ppp9 mtu 1400/d' /etc/ppp/ip-up #Удаляем строки, которые добавляли
	echo "Готово."
	br
	wait
    ;;
    n|N)
    ;;
    *)
    echo "Неправильный ответ"
    wait
    ;;
    esac
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
5) #Работа с Proxy
chosen=5
clear
echo "$title"
echo "$menu5"
myread_dig pick
    case "$pick" in
    1) #Установить Proxy-сервер (на базе Squid)
    echo "Начинаем установку squid"
    yum -y install squid
    echo "Squid был установлен"
    sed -i "/http_access deny all/d" "/etc/squid/squid.conf" #удаляем строку с запретом доступа (ниже добавим снова при необходимости)
    echo "#Ниже добавлены наши наcтройки" >> /etc/squid/squid.conf
    br
    echo 'По умолчанию Proxy работает на порту 3128, но его можно поменять. Хотите изменить порт?'
    myread_yn ans
    port=3128 #ставим порт по умолчанию, далее, если надо, его переопределяем
      case "$ans" in
        y|Y)
        echo 'Укажите порт, на котором должен работать Proxy?'
        read port
        sed -i "/http_port/d" "/etc/squid/squid.conf" #удаляем строку с настройкой порта
        echo "http_port $port" >> /etc/squid/squid.conf #добавляем строку с настройкой порта
        ;;
      esac
    br
    echo "Выберите вариант авторизации на Proxy:"
    echo "1) Свободный доступ (любой, кто знает IP и порт - может воспользоваться)"
    echo "2) Доступ по логину/паролю"
    myread_dig ans
    case "$ans" in
		1)
		echo "http_access allow all" >> /etc/squid/squid.conf
		echo 'Был открыт доступ всем пользователям'
		br
		;;
		2)
		case "$osver1" in
			4|5)
			installed htpasswd
			if [ $exist == false ]; then yum -y install httpd; fi #устанавливаем httpd ради htpasswd, если её ещё нет
			;;
			6|7)
			installed htpasswd
			if [ $exist == false ]; then yum -y install httpd-tools; fi #устанавливаем утилиту htpasswd, если её нет
			;;
		esac
		touch /etc/squid/internet_users #создаем файл с логинами-паролями
		chmod 440 /etc/squid/internet_users #выставляем права на этот файл
		chown squid:squid /etc/squid/internet_users
		ncsa_path=$(find / -name "ncsa_auth") #определяем путь ncsa_auth
		if [ "$ncsa_path" == "" ]; then ncsa_path=$(find / -name "basic_ncsa_auth"); fi #если ncsa_auth не найден, пробуем искать basic_ncsa_auth
		if [ "$ncsa_path" == "" ]; then ncsa_path=$(find / -name "*ncsa_auth"); fi #если и теперь ncsa_auth не найден, пробуем искать другой ncsa_auth
		br
		echo "Укажите логин пользователя:"
		read login
		login_lower=$(echo $login | tr [:upper:] [:lower:]) #Перевели логин в нижний регстр, без этого авторизация вообще не будет проходить
		htpasswd /etc/squid/internet_users $login_lower
		echo "auth_param basic program $ncsa_path /etc/squid/internet_users " >> /etc/squid/squid.conf
		echo "auth_param basic children 32" >> /etc/squid/squid.conf #кол-во юзеров
		echo "auth_param basic realm Enter login and password to use this Proxy " >> /etc/squid/squid.conf #приветственная фраза
		echo "auth_param basic credentialsttl 8 hours " >> /etc/squid/squid.conf #На сколько запоминать авторизацию
		echo "acl internet_users proxy_auth REQUIRED " >> /etc/squid/squid.conf
		echo "http_access allow internet_users " >> /etc/squid/squid.conf
		echo "http_access deny all " >> /etc/squid/squid.conf #запретили доступ всем, кроме авторизованных пользователей
		;;
		*)
		echo "Неправильный выбор. Аварийный выход."
		wait
		exit
		;;
    esac
    #открываем порт в iptables
    br
    echo "Сейчас откроем порт в iptables, чтобы можно было подключиться к серверу"
    openport in tcp $port
    br
      echo 'По умолчанию Proxy не является анонимным и можно определить Ваш IP, когда Вы им пользуетесь'
      echo 'Хотите сделать Ваш Proxy полностью анонимным?'
      myread_yn ans
      case "$ans" in
        y|Y)
       br
       echo 'Имейте ввиду, что такой Proxy-сервер нарушает правила протокола HTTP и является НЕЗАКОННЫМ.'
       echo 'Всю ответственность за такой сервер - несёте вы. Всё ещё хотите продолжить?'
       myread_yn ans
        case "$ans" in
          y|Y)
cat >> /etc/squid/squid.conf <<END
via off
forwarded_for delete
END
          ;;
        esac
        ;;
      esac
    br
    echo 'Вы хотите настроить Proxy таким образом, чтобы можно было использовать программы, типа Proxifier?'
    echo 'В этом случае будет разрешен проброс SSL туннеля на порт 80. Если вы не уверены, ответьте "нет"'
    myread_yn ans
        case "$ans" in
          y|Y)
          sed -i -e '/http_access deny CONNECT !SSL_ports/d' /etc/squid/squid.conf #Удаляем из конфига строчку http_access deny CONNECT !SSL_ports
          echo '#http_access deny CONNECT !SSL_ports' >> /etc/squid/squid.conf #возвращаем ее назад в закомментированном виде"
          ;;
        esac
    br
    echo "Добавляем Squid в автозагрузку..."
    chkconfig squid on
    br
    service squid restart
    br
    echo "Proxy-сервер был успешно настроен. Если подключение к нему есть, но трафик не идёт, то, возможно"
    echo "проблема в MTU. Вы можете его настроить в соответствующем разделе."
    br
	whatismyipext
    echo "Параметры вашего Proxy:"
    echo "IP: $ipext"
    echo "Порт: $port"
    echo "Пользователь: $login"
    br
    wait
    ;;
    2) #Удалить Proxy (Squid)
    echo "Будет удален Proxy-сервер (Squid), а также файл настроек и файл"
    echo "с логинами/паролями пользователей. Продолжить?"
    myread_yn ans
    case "$ans" in
		y|Y)
		echo "Начинаем удаление squid..."
		uninstall -y squid
		rm -f /etc/squid/squid.conf
		rm -f /etc/squid/internet_users
		br
		echo 'Squid был удален'
		wait
		;;
	esac
    ;;
    3) #Поменять MTU для интерфейса
    echo 'На каком интерфейсе вы хотите поменять mtu? (обычно на VPS это venet0:0 или eth0)'
    read interface
    echo 'Какой mtu установить?'
    read mtu
    mtu_change $interface $mtu
    echo 'Для интерфейса '$interface' был успешно установлен MTU '$mtu
    wait
    ;;
    4) #Открыть файл настроек Squid
    edit /etc/squid/squid.conf
    ;;
    5) #Добавить пользователей Proxy
	br
	case "$osver1" in
		4|5)
			installed htpasswd
			if [ $exist == false ]; then yum -y install httpd; fi #устанавливаем httpd ради htpasswd, если её ещё нет
		;;
		6|7)
			installed htpasswd
			if [ $exist == false ]; then yum -y install httpd-tools; fi #устанавливаем утилиту htpasswd, если её нет
		;;
	esac
	br
	echo "Укажите логин пользователя:"
	read login
	login_lower=$(echo $login | tr [:upper:] [:lower:]) #Перевели логин в нижний регстр, без этого авторизация вообще не будет проходить
	htpasswd /etc/squid/internet_users $login_lower    
	br
	echo "Пользователь $login был успешно добавлен в файл настроек"
	wait
    ;;
    6) #Открыть файл с логинами/паролями пользователей Proxy
    clear
    br
    echo "ВНИМАНИЕ! В этом файле содержатся не пароли пользователей, а их хэш-суммы!"
    echo "Редактировать пароли в этом файле нельзя! Вы можете отредактировать только логин."
	echo "Из этого файла Вы можете просто посмотреть какие у Вас есть пользователи и можете удалить кого-то."
	echo "Для удаления пользователя просто сотрите соответствующую строку и сохраните файл."
    echo "Если нужно изменить пароль - просто создайте заново пользователя с тем же логином."
    br
    wait
    edit /etc/squid/internet_users
    ;;    
    7) #Перезапустить сервис Proxy (Squid)
    service squid restart
    echo 'Готово'
    wait
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
6) #Работа с файлами и программами
chosen=6
clear
echo "$title"
echo "$menu6"
myread_dig pick
    case "$pick" in
    1) #Установить какую-либо программу
    echo "Укажите название пакета который нужно установить"
    read answer
    yum -y install $answer
    br
    echo "Готово."
    wait
    ;;
    2) #Удалить какую-либо программу
    echo "Укажите название пакета который нужно удалить"
    read answer
    yum erase $answer
    br
    echo "Готово."
    wait
    ;;
    3) #Удалить какую-либо программу со всеми зависимостями
    #CentOS5
    if [ $osver1 -eq 5 ]; then echo "Данная функция не поддерживается на CentOS 5.x"; wait
    else
        echo "Укажите название пакета который нужно полностью удалить"
        read answer
        uninstall $answer
        br
        echo "Готово."
        wait    
    fi
    ;;
    4) #Посмотреть сколько свободного места на диске
    br
    df -h
    br
    wait    
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор"
    wait
    ;;
    esac
;;
7) #Очистка системы
chosen=7
clear
echo "$title"
echo "$menu7"
myread_dig pick
    case "$pick" in
    1) #Очистить кэш yum
    yum clean all
    br
    echo "Готово."
    wait
    ;;
    2) #Удалить логи Apache, Nginx, Squid и прочие логи
    echo "Внимание! Будут удалены все архивные логи Apache и NginX, кроме сегодняшних."
    echo "А также будут удалены все логи Squid (Proxy), логи неудачного входа в систему"
    echo "(btmp, secure), которые часто копятся из-за попыток взлома."
    echo "Продолжить?"
    myread_yn ans
    case "$ans" in
		y|Y)
		usedspace1=`df | awk '(NR == 2)' | awk {'print $3'}` #запоминаем сколько было занято места до очистки
		rm -f -v /var/www/httpd-logs/*.gz #удаляем архивные логи Apache
		rm -f -v /var/log/nginx/*.gz #удаляем архивные логи Nginx
		del_squid() #упаковали удаление этих логов в функцию потому, что без этого, почему-то не скрывается вывод ошибок. о_О
			{
			cat /dev/null > /var/log/squid/access.log #удаляем логи squid
			cat /dev/null > /var/log/squid/cache.log #удаляем логи squid
			}
		del_squid 2>/dev/null
		cat /dev/null > /var/log/btmp #очищаем логи неудачных попыток входа
		rm /var/log/btmp-* -f #удаляет логи за другие даты
		cat /dev/null > /var/log/secure #очищаем сообщения безопасности/авторизации
		rm /var/log/secure-* -f #удаляет логи за другие даты
		service httpd restart 2>/dev/null
		service nginx restart 2>/dev/null
		usedspace2=`df | awk '(NR == 2)' | awk {'print $3'}` #смотрим сколько занято теперь
		let freespace=$usedspace1-$usedspace2 #столько места освободили в байтах
		let freespace=$freespace/1024 #столько места освободили в Мб
		br
		echo "Готово. Логи были очищены и было освобождено $freespace Мб."
		br
		wait    
    ;;
    esac
    ;;
    3) #Удалить логи Apache конкретного пользователя
    br
    echo "Введите логин ispmanager (обычно в нижнем регистре!) для удаления его старых логов:"
    read answer
    rm -f /var/www/$answer/data/logs/*.gz
    br
    echo "Готово."
    wait
    ;;
    4) #Посмотреть сколько свободного места на диске
	br
    df -h
    br
    wait    
    ;;
    0)
    chosen=0
    ;;
    *)
    echo "Неправильный выбор. Нажмите любую клавишу, чтобы продолжить."
    wait
    ;;
    esac
;;
8) #терминал
chosen=8
clear
echo '┌──────────┐'
echo '│ Терминал │'
echo '└──────────┘'
echo "Здесь вы можете ввести любую команду, которую поддерживает bash."
echo "Кроме этого, поддерживаются внутренние команды $title"
echo 'Такие как: myinstall, uninstall, openport, changelog, updatescript, about и др.'
echo 'Для выхода из терминала наберите "exit" или "quit".'
br
echo "Введите команду:"
read cmd
if [[ "$cmd" == "exit" || "$cmd" == "quit" ]]
then
  chosen=0
else
  br
  $cmd
  br
  wait
fi
;;
9) #Обновить Breeze Easy Shell
echo "обновляю..."
updatescript
repeat=false
sh $0
exit 0
;;
0)
repeat=false
;;
*)
echo "Неправильный выбор."
wait
;;
esac
done
echo "Скрипт ожидаемо завершил свою работу."
clear
