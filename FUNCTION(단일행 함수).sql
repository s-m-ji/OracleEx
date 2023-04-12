/*
    <함수>
    컬럼의 값을 읽어서 계산 결과를 반환한다.
    - 단일행 함수 : 조회된 갯수만큼 반환
    - 그룹 함수 : 여러 행을 읽어서 하나의 값으로 반환
*/

/*
    ========== ========== [단일행 함수] <문자 관련 함수> ========== ==========
    1) length / lengthb    => 문자열의 갯수를 알 수 있음
    - length(값) : 글자수를 반환
    - lengthb(값) : 글자의 바이트수를 반환
        한글 3byte, 영어/숫자/특수문자 1byte  
        *사용하는 문자코드에 따라 한글은 인식되는 바이트가 다를 수 있음..!
        
    값 : 컬럼, 문자열(리터럴)
    
    dual 테이블 : 함수 테스트용으로 자주 사용되는 테이블
    sys 사용자가 소유하는 테이블이라서 모든 사용자가 접근 가능하다
    한 개의 행과 한 개의 컬럼을 가지고 있는 더미 테이블
    함수의 결과를 조회하기 위해 임시로 사용하는 테이블
*/

select * from dual;

select length('오라클'), lengthb('오라클') from dual;

-- 현재 사용하는 문자코드를 조회
-- KO16MSWIN949 : 2byte, AL32YTF8 : 3byte
select * from nls_database_parameters
where parameter = 'NLS_CHARACTERSET';

select emp_name, length(emp_name), lengthb(emp_name)
from emp;


/*
    2) instr
    - instr(값, 문자[,position])
    - 지정한 위치부터 지정된 숫자번째로 나타나는 문자의 시작위치를 반환한다
*/

select instr('aabaacccaaacab', 'b') from dual; 
--b의 위치값(3번째)를 반환
select instr('aabaacccaaacab', 'b', 5,1) from dual; 
-- 5번째 위치에서부터 1번째 'b'의 자리를 반환
select instr('aabaacccaaacabbb', 'b', -1,1) from dual; 
-- 뒤에서 1번째 위치에서부터 1번째 'b'의 자리를 반환

select * from DEPT where instr('10|20|30', DEPARTMENT_ID)>0;

select emp_name || '님 안녕하새우~~~' from emp;

select DEPARTMENT_ID, instr('10|20|30', DEPARTMENT_ID)
-- 조회된 DEPARTMENT_ID를 instr 함수에 적용하는겨
                    -- instr('10|20|30', 10)
                    -- instr('10|20|30', 20)
                    -- instr('10|20|30', 30) 이렇게 가져온다는겨
from DEPT where instr('10|20|30', DEPARTMENT_ID)>0;

/* 
    3) lpad/rpad    => 문자열 통일감 있게 표시할 수 있음 
    - lpad/rpad(값, 길이[,'덧붙일 문자'])
    - 제시된 값에 임의의 문자를 왼쪽 또는 오른쪽에 붙여서
    최종 n길이만큼 문자열을 반환한다.
*/

-- 20개의 공간을 만들어서 정렬 후 나머지는 공백/지정문자로 채움
select lpad(email, 20) from emp; 
select rpad(email, 20, ' ^_^ ')  from emp; 

/*
    4) ltrim/rtrim
    - ltrim/rtrim(값[,제거할 문자])
    - 문자열의 왼쪽 혹은 오른쪽에서 문자를 찾아 제거 후 결과를 반환

    5) trim
    - trim([leading|trailing|both] '제거할 문자값' from 값(컬럼|리터럴))
    - 문자값 앞,뒤,양쪽에 있는 지정 문자를 제거한 나머지를 반환
    - 문자값 생략 시 양쪽 공백을 제거한다
*/

select ltrim('           냥')from dual;  -- 왼쪽 공백 제외
select length(rtrim('냥           '))from dual;  -- 오른쪽 공백 제외 후 문자열 갯수
select ltrim(emp_name,'A') from emp;    -- 'A'로 시작하는 이름 제외
select ltrim(rtrim('     냥     '))from dual;    -- 양쪽 공백 모두 제외

select ltrim('0001111111', '0') from dual;      -- 왼쪽 '0' 제외
select trim(both '0' from '00011110000') from dual;     -- 양쪽 모두 '0'제외
select trim('     1111    ') from dual;     -- 양쪽 공백 모두 제외

select trim(leading 'z' from 'zzz1234567zzz') from dual;    -- 왼쪽 'z' 제외
select trim(trailing 'z' from 'zzz1234567zzz') from dual;   -- 오른쪽 'z' 제외

/*
    6) substr
    - substr(값, position [,length])
    - 문자데이터에서 지정한 위치부터 지정한 갯수만큼의 문자열을 추출 후 변환
    
*/

-- 문자열을 바이트 단위로 끊어오기
select substrb('hello',2,3) from dual;
select substrb('안녕하세요',2,3) from dual; 
-- ' 녕'이라고 출력됨 : 한 글자당 2~3바이트를 차지하기때문에 3개 끊어오기가 이상함

select substr('sakuraishow',7) from dual; -- 7번째부터 끝까지
select substr('sakuraishow',7,2) from dual; -- 7번째부터 2개까지
select substr('sakuraishow',-7,2) from dual; -- 역방향 7번째부터 다시 정방향 2개까지

select emp_name, instr(emp_name, ' '),
substr(emp_name, instr(emp_name, ' ')+1),
substr(emp_name, instr(emp_name, ' ')+1)
from emp; -- +1 안하면 공백부터 출력함

select emp_name, substr(emp_name, 0, instr(emp_name, ' ')-1) from emp;

-- 시작위치(position) : 기본값 : 1
-- position >= 0 시작부터 끝방향으로 왼쪽에서 오른쪽으로 찾기
-- position < 0 오른쪽에서 왼쪽으로 찾기

-- 테이블 업데이트
update emp set email = email || '@jungang.com';
select * from emp;

select email, '사용자ID: ' || substr(email, 1, instr(email, '@')-1) from emp;
-- 오라클에서는 문자열 인덱스를 1부터 시작해서 그런게 아닐지?라고 추측하셨음.. 
-- 0: 문자의 맨 처음부터 시작, 1: 첫번째부터 시작 => 어쨌거나 결과는 동일함

select substr('123@jungang.com', 1, instr('123@jungang.com', '@')-1) from dual;

-- 주민번호에서 성별코드 찾기
select '1111292935310' from dual;
select substr('1111292935310', 7,1)from dual;

select rpad(substr('1111292935310',1,7),14,'*')from dual;

/*
    7) lower / upper / initcap
    lower|upper|initcap (컬럼|문자값)
    - lower : 모두 소문자로 변경
    - upper : 모두 대문자로 변경
    - initcap : 단어 앞 글자마다 대문자로 변경
*/

select emp_name, lower(emp_name), upper(emp_name), initcap(emp_name)
from emp;

/*
    8) concat
    - concat(컬럼|'문자열', 컬럼|'문자열')
    - 문자데이터 2개를 전달받아서 하나로 합친 후 결과를 반환 (인수를 3개 이상 넣는건 안된다)
*/

select concat('메머드', '커피')from dual;
select concat('메머드', '맘모스', '커피')from dual;
select concat(concat('메머드', '맘모스'), '커피')from dual;
select '메머드' || '맘모스' || '커피' from dual;

select concat (employee_id, department_id) from emp;

/*
    9) replace      => 치환
    - replace(컬럼|'문자값', 변경할 문자, 새로운 문자)
*/

select replace('서울시 강남구 이화여대길', '강남구', '서대문구') "주소 바꾸기" from dual;
select replace('강남구 서울시 강남구 이화여대길 강남구', '강남구', '서대문구') from dual;
-- 여러개가 있을 시 모두 바뀜

select replace(email, '@jungang.com' ,'') from emp;
update emp set email = replace(email, '@jungang.com' ,'');
select * from emp;







