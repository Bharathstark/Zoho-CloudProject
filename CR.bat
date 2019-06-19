set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_77\bin
set ANT_HOME=C:\Users\admin\Desktop\apache-ant-1.6.5
set CLASSPATH=%CLASSPATH%;%ANT_HOME%\lib\ant.jar;%ant_home%\jre\lib\rt.jar;
set Path=%JAVA_HOME%
jar -cvf 1.jar com
copy /Y 1.jar ../lib
echo "file copied...."