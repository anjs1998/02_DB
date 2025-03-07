-- SQL(Structure Query Language, 구조적 질의 언어)
-- 데이터베이스와 상호작용을 하기 위해 사용하는 표준 언어
-- 데이터의 조회, 삽입, 수정, 삭제 등

/*
 * SELECT(DML또 또는 DQL) : 조회
 * - 데이터를 조회(SELECT)하면 조건에 맞는 행들이 조회됨
 * 이때 조회된 행들의 집합을 "RESULT SET" 이라고 한다.
 * 
 * 
 * - RESULT SET은 0개 이상의 행을 포함할 수 있다.
 * 왜 0개? 조건에 맞는 행이 없을 수도 있어서
 * 
 * 
 * ***********/


--[작성법]
--SELECT 컬럼명 FROM 테이블명;
--> 테이블의 특정 컬럼을 조회하겠다.
SELECT * FROM EMPLOYEE; -- "*" : ALL, 전부, 모두
-- EMPLOYEE 테이블의 모든 컬럼을 조회하겟다
-- EMPLOYEE 테이블에서 사번, 직원이름, 휴대전화번호 컬럼만 조회
-- SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;


-------------------------------------------------------

-- < 컬럼 값 산술연산 > 
-- 컬럼 값 : 테이블 내 한칸
-- ( == 한 셀)에 작성된 값(DATA)

-- EMPLOYEE 테이블에서 모든 사원의 사번, 이름, 급여, 연봉 조회

SELECT EMP_ID, EMP_NAME, SALARY, SALARY * 12 FROM EMPLOYEE;

SELECT EMP_NAME + 10 FROM EMPLOYEE; -- 산술 연산은 숫자타입만 가능하다!

SELECT '같음' FROM DUAL WHERE 1 = '1';
-- 더미테이블 : 테스트용 가상의 테이블
-- 오라클에서는 DUAL이라는 더미테이블을 이용한다.
--''는 문자열을 의미

-- NUMBER타입인 1(숫자)과 문자열인 '1'이 같다고 인식해버린다.

-- 문자열 타입이어도 저장된 값이 숫자면 자동으로 형변환하여 연산 가능

SELECT EMP_ID + 10 FROM EMPLOYEE;

------------------------------------------------

--날짜(DATE) 타입 조회

-- EMPLOYEE 테이블에서 이름, 입사일, 오늘 날짜 조회

SELECT EMP_NAME, HIRE_DATE, SYSDATE FROM EMPLOYEE;
-- 2025-03-07 15:47:54
-- SYSDATE : 시스템 상의 현재시간(날짜)를 나타내는 상수
SELECT SYSDATE FROM DUAL;



---------------------------------

-- 날짜 + 산술연산( + , - )

SELECT SYSDATE - 1, SYSDATE, SYSDATE + 1
FROM DUAL;

-- 날짜에 +, - 연산시 일 단위로 계산이 진행된다


-----------------------------
-- 별칭 지어주기

/*
 * 컬럼명 AS 별칭 : 별칭 띄어쓰기 x, 특수문자 X, 문자만 O
 * 
 * 컬럼명 AS "별칭" : 별팅 띄어쓰기 O, 특수문자 O, 문자 O
 * 
 * AS 생략 가능
 * 
 * ***********/
--별칭 예제
SELECT SYSDATE -1 "하루 전",SYSDATE AS 현재시간, SYSDATE + 1 AS "내일"
FROM DUAL;

-- JAVA 리터럴 : 값 자체를 의미
-- DB 리터럴 : 임의로 지정한 값을 기존 테이블에 존재하는 값처럼 사용하는것

--> (필수) DB의 리터럴 표기법 '' 홑따옴표

SELECT EMP_NAME, SALARY, '원 입니다' FROM EMPLOYEE;
--리터럴 적용 예제

------------------------------------------
-- DISTINCT : 조회 시 컬럼에 포함된 중복 값을 한번만 표기
-- 주의사항 1) DISTINCT 구문은 SELECT마다 딱 한번씩만 작성 가능
-- 주의사항 2) DISTINCT 구문은 SELECT 제일 앞에 작성되어야만 한다.


SELECT DISTINCT DEPT_CODE, JOB_CODE FROM EMPLOYEE;

-- SELECT 절 : SELECT 컬럼명
-- FROM 절 : FROM 테이블명
-- WHERE 절 : WHERE 컬럼명 연산자 값;
-- ORDER BY 절 : ORDER BY 컬럼명 | 별칭 | 컬럼 순서 [ASC | DESC] [NULLS FIRST | LAST]


--EMPLOYEE TABLE
--급여가 3백만원 초과인 사원의
--사번, 이름, 급여, 부서코드를 조회해라

SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE
WHERE SALARY > 3000000; -- WHERE 절


-- 비교 연산자 : > , <, <=, <=, = (==가 아니다!), !=, <>(이것도 같지 않다는 뜻이다.)

-- EMPLOYEE 테이블에서
-- 부서코드가 'D9'인 사원의
-- 사번(EMP_ID), 이름(EMP_NAME), 부서코드(DEPT_CODE), 직급코드(JOB_CODE)를 조회

 SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE 
 FROM EMPLOYEE 
 WHERE DEPT_CODE = 'D9';
 
 -- CTRL + SHIFT + ↑↓
 -- CTRL + ALT + ↑↓
 
 ----------------------------------
 --논리 연산자( AND, OR)
 
 -- EMPLOYEE 테이블에서 급여가 300만원 미만 또는 500만원 이상인 사원의
 -- 사번, 이름, 급여, 전화 번호 조회
 
SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE
WHERE SALARY < 3000000 OR SALARY >= 5000000;

--EMPLOYEE 테이블에서
--급여가 300만원 이상 500만원 미만인 사원의
-- 사번, 이름, 그여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE
WHERE SALARY < 3000000 AND SALARY >= 5000000;

-- BETWEEN A AND B : A 이상 B 이하

--EMPLOYEE 테이블에서
--급여가 300만원 이상 500만원 미만인 사원의
-- 사번, 이름, 그여, 전화번호 조회
SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE
WHERE SALARY BETWEEN 3000000 AND 6000000;

SELECT EMP_ID, EMP_NAME, SALARY, PHONE 
FROM EMPLOYEE
WHERE SALARY NOT BETWEEN 3000000 AND 6000000;

--날짜(DATE에 BETWEEN 이용하기)

-- EMPLOYEE 테이블에서 입사일이 1990-01-01 ~ 1990-12-31 인 사원의
-- 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE 
FROM EMPLOYEE
WHERE HIRE_DATE BETWEEN '1990-01-01' AND '1999-12-31';
