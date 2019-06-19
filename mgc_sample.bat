echo %*
set JAVA_HOME=C:\Program Files (x86)\Java\jdk1.8.0_77
if NOT y%TEMP_HOME%==y set JAVA_HOME=%TEMP_HOME%
set ANT_HOME=C:\Users\admin\Desktop\apache-ant-1.6.5
set CLASSPATH=%CLASSPATH%;%ANT_HOME%\lib\ant.jar;%ant_home%\jre\lib\rt.jar;
set prod_home=C:\Users\admin\Desktop\AdventNet\ME\ServiceDesk
if not x%comp_home%==x set prod_home=%comp_home%
mkdir %prod_home%\lib\classes
C:\Users\admin\Desktop\apache-ant-1.6.5\bin\ant -f=C:\Users\admin\Desktop\AdventNet\ME\ServiceDesk\lib\classes\build.xml -Dfile=%* -Ddestdir=%prod_home%\lib\classes -Dprodbase=%PROD_HOME% -Doutputdir=%PROD_HOME%\lib 

