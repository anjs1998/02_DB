/**
 * 
 * 
 * SUBQUERY (서브쿼리 == 내부쿼리)
 * 
 * - 하나의 SQL문안에 포함된 또다른 SQL문
 * 
 * - 메인쿼리(== 외부쿼리, 기준쿼리)를 위해 보조역할을 하는 쿼리문
 * 
 * -- 메인쿼리가 SELECT문일때
 * -- SELECT, FROM, WHERE, HAVING 절에서 사용가능
 * 
 * 
 * 
 */

--서브쿼리 예시1.
-- 부서코드가 노옹철 사원과 같은 부서 소속의 직원의
-- 이름, 부서코드 조회 

-- 1) 노옹철 사원의 부서코드 조회 (서브쿼리)

SELECT DEPT_CODE
FROM EMPLOYEE
WHERE EMP_NAME = '노옹철'; -- 'D9'

-- 2) 부서코드가 'D9'인 직원의 이름, 부서코드 조회( 메인쿼리 )

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D9';

-- 3) 부서코드가 노옹철 사원과 같은 소속의 직원 명단 조회
--> 위의 2개의 단계를 하나의 쿼리로!!

SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = (SELECT DEPT_CODE
										FROM EMPLOYEE
										WHERE EMP_NAME = '노옹철');


-- 서브쿼리 예시2.
-- 전 직원의 평균 급여보다 많은 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여 조회

-- 1) 전 직원의 평균 급여 조회
SELECT CEIL( AVG(SALARY) )
FROM EMPLOYEE; -- 3,047,633

-- 2) 직원 중 급여가 3,047,633원 이상인 사원들의
-- 사번, 이름, 직급코드, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY >= (SELECT CEIL( AVG(SALARY) )
									FROM EMPLOYEE);


-------------------------------------------------------

/* 서브쿼리 유형
 * 
 * - 단일행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 1개일 때
 * 
 * - 다중행 (단일열) 서브쿼리 : 서브쿼리의 조회 결과 값의 개수가 여러개일 때
 * 
 * - 다중열 서브쿼리 : 서브쿼리의 SELECT 절에 나열된 항목수가 여러개일 때
 * 
 * - 다중행 다중열 서브쿼리 : 조회 결과 행 수와 열 수가 여러개일 때
 * 
 * - 상(호연)관 서브쿼리 : 서브쿼리가 만든 결과 값을 메인쿼리가 비교 연산할 때
 * 						메인쿼리 테이블의 값이 변경되면 
 * 						서브쿼리의 결과값도 바뀌는 서브쿼리
 * 
 * - 스칼라 서브쿼리 : 상관 쿼리이면서 결과 값이 하나인 서브쿼리
 * 
 * ** 서브쿼리 유형에 따라 서브쿼리 앞에 붙는 연산자가 다름 ** 
 * 
 * */			

---------------------------------------------------------------
--1. 단일행 서브쿼리 (SINGLE ROW SUBQUERY)

--서브쿼리의 조회 결과 값의 개수가 1개인 서브쿼리

-- 단일행 서브쿼리 앞에는 비교 연산자 사용
-- < , > , <= , >=, = , != 또는 <> 또는 ^=


-- 전 직원의 급여평균보다 많은(초과) 급여를 받는 직원의
-- 이름, 직급명, 부서명, 급여를 직급 순으로 정렬하여 조회

SELECT EMP_NAME, JOB_NAME, DEPT_TITLE, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)

WHERE SALARY > ( SELECT AVG(SALARY) FROM EMPLOYEE)
ORDER BY JOB_CODE;
-- SELECT절에 명시되지 않은 컬럼이라도
-- FROM, JOIN으로 인해 테이블상 존재하는 컬럼이라면
-- ORDER BY절 사용가능

--가장 적은 급여를 받는 직원의
--사번, 이름, 직급명, 부서코드, 급여, 입사일 조회


--서브쿼리
SELECT MIN(SALARY) FROM EMPLOYEE;

--메인쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
WHERE SALARY = (SELECT MIN(SALARY) FROM EMPLOYEE);

--노옹철 사원의 급여보다 많이(초과) 받는 직원의 
--사번, 이름, 부서명, 직급명, 급여 조회
SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철';

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
FROM EMPLOYEE
JOIN JOB USING (JOB_CODE)
LEFT JOIN  DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE SALARY > (SELECT SALARY FROM EMPLOYEE WHERE EMP_NAME = '노옹철' );

-- 부서별(부서가 없는 사람 포함) 급여의 합계 중
-- 가장 큰 부서의 부서명, 급여 합계를 조회

-- 1) 부서별 급여 합 중 가장 큰 값 조회(서브쿼리)
SELECT MAX(SUM(SALARY))
FROM EMPLOYEE 
GROUP BY DEPT_CODE; -- 17,700,000

-- 2) 부서별 급여 합이 17,700,000인 부서의 부서명과 급여합 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = 17700000;

-- 3) 위의 두 쿼리를 합쳐 부서별 급여 합이 가장 큰 부서의
-- 부서명, 급여합 조회
SELECT DEPT_TITLE, SUM(SALARY)
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_TITLE
HAVING SUM(SALARY) = (SELECT MAX(SUM(SALARY))
											FROM EMPLOYEE 
											GROUP BY DEPT_CODE);


--------------------------------------------------------

-- 2.다중행 서브쿼리(MULTI ROW SUBQUERY)

--서브쿼리의 조회 결과 값의 개수가 여러행일때
/*
 * >> 다중행 서브쿼리 앞에는 일반 비교연산자 사용 불가
 * 
 * -IN / NOT IN : 여러개의 결과값 중에서 한개라도 일치하는 값이 있다면, 혹은 없다면 이라는 의미
 * 
 * 
 * -> ANY , < ANY : 여러 개의 결과값 중에서 한개라도 큰/ 작은 경우
 * 								--> 가장 작은값보다 큰가? / 가장 큰값보다 작은가?
 * 
 * -> ALL, < ALL : 여러개의 결과값의 모든 값보다 큰/ 작은 경우
 * 								--> 가장 큰 값보다 큰가? / 가장 작은 값보다 작은가?
 * 
 * - EXISTS / NOT EXISTS : 값이 존재하는가? / 존재하지 않는가?
 * 
 * 
 * 
 **/

-- 부서별 최고 급여를 받는 직원의
-- 이름, 직급, 부서, 급여를
-- 부서 오름차순으로 정렬하여 조회
-- 부서별 최고 급여 조회( 서브쿼리 )

SELECT MAX(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; -- 7행 1열( 다중행 )

-- 메인쿼리 + 서브쿼리
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, SALARY

FROM EMPLOYEE

WHERE SALARY  IN (SELECT MAX(SALARY)
									FROM EMPLOYEE
									GROUP BY DEPT_CODE)
ORDER BY DEPT_CODE;



-- 사수에 해당하는 직원에 대해 조회
-- 사번, 이름, 부서명, 직급명, 구분(사수/사원) 조회

--* 사수 == MANAGER_ID 컬럼에 작성된 사번

SELECT * FROM EMPLOYEE;

-- 1) 사수에 대항하는 사원번호 조회
SELECT DISTINCT MANAGER_ID
FROM EMPLOYEE
WHERE MANAGER_ID IS NOT NULL;

-- 2) 직원의 사번, 이름, 부서명, 직급명 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);

-- 3) 사수에 해당하는 직원에 대한 정보 추출 조회(구분 '사수')
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME,'사수' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
									FROM EMPLOYEE
									WHERE MANAGER_ID IS NOT NULL);


-- 4) 일반 직원에 해당하는 사원들 정보 조회(구분은 '사원')

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME '사원' 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
									FROM EMPLOYEE
									WHERE MANAGER_ID IS NOT NULL);

-- 5) 3,4의 조회 결과를 UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
									FROM EMPLOYEE
									WHERE MANAGER_ID IS NOT NULL);
UNION
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
WHERE EMP_ID IN (SELECT DISTINCT MANAGER_ID
									FROM EMPLOYEE
									WHERE MANAGER_ID IS NOT NULL);


-- 2. 선택함수 사용
--> DECODE();
--> CASE WHEN 조건1 THEN 값1 .. ELSE END

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
CASE WHEN EMP_ID IN (SELECT DISTINCT MANAGER_ID
									FROM EMPLOYEE
									WHERE MANAGER_ID IS NOT NULL)
				THEN '사수'
				ELSE '사원'
		END 구분
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
ORDER BY EMP_ID;



-- 대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

-- > ANY : 가장 작은 값보다 크냐?

-- 1) 직급이 대리인 직원들의 사번, 이름, 직급, 급여 조회(메인쿼리)
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리';

-- 2) 직급이 과장인 직원들의 급여 조회(서브쿼리)
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장';

-- 3)  대리 직급의 직원들 중에서
-- 과장 직급의 최소 급여보다
-- 많이 받는 직원의
-- 사번, 이름, 직급명, 급여 조회

--방법 1) ANY 를 이용하기
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ANY (SELECT SALARY
										FROM EMPLOYEE
										JOIN JOB USING(JOB_CODE)
										WHERE JOB_NAME = '과장');
-- 		> ANY : 가장 작은값보다 큰가?
--> 과장 직급 최소급여보다 큰 급여를 받는 대리인가?
-- 		< ANY : 가장 큰 값보다 작은가?
--> 과장 직급 최대급여보다 적은 급여를 받는 대리인가?


--방법 2) MIN을 이용해서 단일행 서브쿼리로 만듦
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '대리'
AND SALARY > ( SELECT MIN(SALARY) 
							FROM EMPLOYEE
							JOIN JOB USING(JOB_CODE)
							WHERE JOB_NAME = '과장');


-- 차장 직급의 급여 중 가장 큰 값보다 많이 받는 과장 직급의 직원
-- 사번, 이름, 직급, 급여 조회

--> ALL, < ALL : 가장 큰 값보다 크냐? / 가장 작은값보다 작냐?

-- 서브쿼리
SELECT SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '차장';

--메인 쿼리 + 서브쿼리
SELECT EMP_ID, EMP_NAME, JOB_NAME, SALARY
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
WHERE JOB_NAME = '과장'
AND SALARY > ALL(SELECT SALARY
									FROM EMPLOYEE
									JOIN JOB USING(JOB_CODE)
									WHERE JOB_NAME = '차장' )	;


--					> ALL: 가장 큰 값보다 큰가?
--> 차장 직급의 최대급여보다 많이 받는 과장인가?

-- 					< ALL : 가장 작은 값보다 작은가?
--> 차장 직급의 최소급여보다 적게 받는 과장인가?

-- 서브쿼리 중첩 사용(응용편)

-- LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우 LOCAL_CODE와
-- DEPARTMENT 테이블의 LOCATION_ID와 동일한 DEPT_ID가
-- EMPLOYEE 테이블의 DEPT_CODE와 동일한 사원 조회해라

-- 1)  LOCATION 테이블에서 NATIONAL_CODE가 KO인 경우 LOCAL_CODE 조회
SELECT LOCAL_CODE
FROM LOCATION
WHERE NATIONAL_CODE = 'KO'; -- L1(단일행 서브쿼리)


--2) DEPARTMENT 테이블에서 위의 결과(L1)와 동일한 LOCATION_ID를 가진 DEPT_ID 조회
SELECT DEPT_ID
FROM DEPARTMENT
WHERE LOCATION_ID = (SELECT LOCAL_CODE
											FROM LOCATION
											WHERE NATIONAL_CODE = 'KO');
											
											
--3) 최종적으로 EMPLOYEE 테이블에서 위의 결과들과 동일한 DEPT_CODE를 가진 사원 조회
SELECT EMP_NAME, DEPT_CODE
FROM EMPLOYEE
WHERE DEPT_CODE IN (SELECT DEPT_ID
										FROM DEPARTMENT
										WHERE LOCATION_ID = (SELECT LOCAL_CODE
																					FROM LOCATION
																					WHERE NATIONAL_CODE = 'KO'));
																					
																					
																					
--------------------------------------------------
-- 3. (단일행) 다중열 서브쿼리
-- 서브쿼리 SELECT 절에 나열된 컬럼수가 여러개일때

-- 퇴사한 여직원과 같은 부서, 같은 직급에 해당하는
--사원의 이름, 직급코드, 부서코드, 입사일 조회
-- 1) 퇴사한 여직원 조회
SELECT DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';


-- 2) 퇴사한 여직원과 같은 부서, 같은 직급 조회

-- 방법 1) 단일행 단일열 서브쿼리 2개를 사용해서 조회
SELECT DEPT_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';
SELECT JOB_CODE
FROM EMPLOYEE
WHERE ENT_YN = 'Y'
AND SUBSTR(EMP_NO, 8, 1) = '2';

SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE DEPT_CODE = (	SELECT DEPT_CODE
										FROM EMPLOYEE
										WHERE ENT_YN = 'Y'
										AND SUBSTR(EMP_NO, 8, 1) = '2')
AND JOB_CODE = (SELECT JOB_CODE
								FROM EMPLOYEE
								WHERE ENT_YN = 'Y'
								AND SUBSTR(EMP_NO, 8, 1) = '2');

-- 방법 2) 다중열 서브쿼리 사용
--> WHERE 절에 작성된 컬럼 순서에 맞게
-- 서브쿼리의 조회된 컬럼과 비교하여 일치하는 행만 조회
-- 컬럼 순서가 중요!!
SELECT EMP_NAME, JOB_CODE, DEPT_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (	SELECT DEPT_CODE, JOB_CODE
																FROM EMPLOYEE
																WHERE ENT_YN = 'Y'
																AND SUBSTR(EMP_NO, 8, 1) = '2');


-- 4. 다중행 다중열 서브쿼리
-- 서브쿼리 조회 결과 행 수와 열 수가 여러개 일떄

-- 본인이 소속된 직급의 평균 급여를 받고있는 직원의
-- 사번, 이름, 직급코드, 급여 조회
-- 단, 급여와 급여 평균은 만원단위로 조회 TRUNC(컬럼명, -4)

--1) 직급별 평균 급여(서브쿼리)
SELECT JOB_CODE, TRUNC(AVG(SALARY), -4)
FROM EMPLOYEE
GROUP BY JOB_CODE;


--2) 사번, 이름, 직급코드, 급여 조회(메인쿼리 + 서브쿼리)

SELECT EMP_ID, EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE
WHERE (JOB_CODE, SALARY) IN (SELECT JOB_CODE, TRUNC(AVG(SALARY), -4) 
															FROM EMPLOYEE
															GROUP BY JOB_CODE);
-- 5. 상[호연]관 서브쿼리
-- 상관 쿼리는 메인쿼리가 사용하는 테이블값을 서브쿼리가 이용해서 결과를 만듦
-- 메인쿼리의 테이블값이 변경되면 서브쿼리의 결과값도 바뀌게 되는 구조

-- 상관쿼리는 먼저 메인쿼리 한행을 조회하고
-- 해당 행이 서브쿼리의 조건을 충족하는지 확인하여 SELECT를 진행함

-- ** 해석순서가 기존 서브쿼리와는 다르다 **
-- 메인쿼리 1행 -> 1행에 대한 서브쿼리를 수행
-- 메인쿼리 2행 -> 2행에 대한 서브쿼리를 수행...
-- ....
-- 메인쿼리의 행의 수만큼 서브쿼리가 생성되어 진행됨

-- 직급별 급여 평균보다 급여를 많이 받는 직원의
-- 이름, 직급코드, 급여 조회

-- 메인쿼리
SELECT EMP_NAME, JOB_CODE, EMPLOYEE.SALARY 
FROM EMPLOYEE
;


-- 서브쿼리
SELECT AVG(SALARY)
FROM EMPLOYEE
WHERE JOB_CODE = 'J2' ; --8,000,000

-- 상관쿼리
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE MAIN
WHERE SALARY > (SELECT AVG(SALARY)
								FROM EMPLOYEE SUB
								WHERE MAIN.JOB_CODE = SUB.JOB_CODE);

----------------------------------------------------

--사수가 있는 직원의 사번, 이름, 부서명, 사수사번 조회

--> 상관 서브쿼리를 사용하여 각 직원의 MANAGER_ID가
--실제로 직원 테이블의 EMP_ID와 일치하는지 확인

-- 메인쿼리(직원의 사번, 이름, 부서명, 사수사번 조회)

SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID 
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID);

-- 서브쿼리( 사수인 직원 조회 )
SELECT EMP_ID
FROM EMPLOYEE
WHERE EMP_ID = 200;


-- 상관쿼리
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, MANAGER_ID 
FROM EMPLOYEE MAIN
LEFT JOIN DEPARTMENT ON(DEPT_CODE = DEPT_ID)
WHERE MANAGER_ID = (SELECT EMP_ID
										FROM EMPLOYEE SUB
										WHERE SUB.EMP_ID = MAIN.MANAGER_ID);


-----------------------------------------------

-- 부서별 입사일이 가장빠른 사원의
-- 사번, 이름, 부서코드, 부서명(NULL이면 '소속없음')
-- 직급명, 입사일을 조회하고
-- 입사일이 빠른순으로 정렬해라
-- 단, 퇴사한 직원은 제외해라

-- 메인쿼리
SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'),
JOB_NAME, HIRE_DATE
FROM EMPLOYEE
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
WHERE ENT_YN = 'N';



-- 서브쿼리(부서별 입사일이 가장빠른 사원)
SELECT MIN(HIRE_DATE)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';
-- 상관쿼리


SELECT EMP_ID, EMP_NAME, DEPT_CODE, NVL(DEPT_TITLE, '소속없음'),
JOB_NAME, HIRE_DATE
FROM EMPLOYEE MAIN
JOIN JOB USING(JOB_CODE)
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
-- WHERE ENT_YN = 'N' 서브쿼리로 이동
AND HIRE_DATE = (	SELECT MIN(HIRE_DATE)
									FROM EMPLOYEE SUB
									WHERE MAIN.DEPT_CODE = SUB.DEPT_CODE
									AND ENT_YN = 'N'
									OR (SUB.DEPT_CODE IS NULL AND MAIN.DEPT_CODE IS NULL))
ORDER BY HIRE_DATE;

-- 6. 스칼라 서브쿼리
-- SELECT절에 사용되는 서브쿼리 결과로 1행만 반환
-- SQL에서 단일값 '스칼라' 라고함
-- 즉, SELECT절에 작성되는 단일행 단일열 서브쿼리를 스칼라 서브쿼리라고 함.

-- 모든 직원의 이름, 직급, 급여, 전체 사원 중 가장 높은 급여와의 차를 조회
SELECT EMP_NAME, JOB_CODE, SALARY
( SELECT MAX(SALARY) FROM EMPLOYEE ) - SALARY  "급여 차"
FROM EMPLOYEE;


-- 모든 사원의 이름, 직급코드, 급여, 
-- 각 직원들이 속한 직급의 급여 평균을 조회

-- 메인쿼리
SELECT EMP_NAME, JOB_CODE, SALARY
FROM EMPLOYEE;

-- 서브쿼리
SELECT AVG(SALARY)
FROM EMPLOYEE 
WHERE JOB_CODE = 'J1';


-- (스칼라 + 상관쿼리)
SELECT EMP_NAME, JOB_CODE, SALARY,
(SELECT AVG(SALARY)
FROM EMPLOYEE SUB
WHERE SUB.JOB_CODE = MAIN.JOB_CODE) 평균
FROM EMPLOYEE MAIN
ORDER BY JOB_CODE;


-- 모든 사원의 사번, 이름, 관리자사번, 관리자명을 조회
-- 단, 관리자가 없는 경우 '없음'으로 표시

-- 스칼라 + 상관쿼리

SELECT EMP_ID, EMP_NAME, NVL(MANAGER_ID, '없음') "MANAGER_ID", 
(SELECT EMP_NAME FROM EMPLOYEE SUB WHERE SUB.EMP_ID = MAIN.MANAGER_ID) 관리자명
FROM EMPLOYEE MAIN;


-- 7. 인라인 뷰(INLINE-VIEW)
-- FROM 절에서 서브쿼리를 사용하는 경우로
-- 서브쿼리가 만든 결과의 집합(RESULT SET)을 테이블 대신 사용

-- 서브쿼리
SELECT EMP_NAME 이름, DEPT_TITLE 부서
FROM EMPLOYEE
JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID);


--부서가 기술지원부인 모든 컬럼 조회
SELECT *
FROM (SELECT EMP_NAME 이름, DEPT_TITLE 부서
			FROM EMPLOYEE
			JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID))
WHERE 부서 = '기술지원부';

-- 인라인뷰를 활용할 TOP-N분석

-- 전 직원중 급여가 높은 상위 5명의
-- 순위, 이름, 급여 조회

--ROWNUM 컬럼: 행 번호를 나타내는 가상 컬럼

--SELECT, WHERE, ORDER BY절 사용가능

SELECT ROWNUM, EMP_NAME, SALARY
/*1*/FROM EMPLOYEE
/*2*/WHERE ROWNUM <= 5
ORDER BY SALARY DESC;

--> SELECT문의 해석 순서때문에
--급여 상위 5명이 아니라
--조회 순서 상위 5명끼리의 급여 순위 조회됨

--> 인라인뷰를 이용해서 해결 가능!
-- 1) 이름, 급여를 급여 내림차순으로 조회한 결과를 인라인뷰 사용
--> FROM 절에 작성되기 떄문에 해석 1순위
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC;


--2) 메인쿼리 조회 시 ROWNUM을 5 이하까지만 조회
SELECT ROWNUM, EMP_NAME, SALARY
FROM (SELECT EMP_NAME, SALARY FROM EMPLOYEE ORDER BY SALARY DESC) -- 해석순위 1위 FROM 절에서 전체 직원의 SALARY
WHERE ROWNUM <= 5;

-- 급여 평균이 3위 안에 드는 부서의
-- 부서코드, 부서명, 평균급여 조회
--인라인뷰 (+GROUP BY)

SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY AVG(SALARY) DESC;

SELECT DEPT_CODE, DEPT_TITLE, 평균급여
FROM
(SELECT DEPT_CODE, DEPT_TITLE, CEIL (AVG(SALARY)) 평균급여
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON(DEPT_ID = DEPT_CODE)
GROUP BY DEPT_CODE, DEPT_TITLE 
ORDER BY 평균급여 DESC)
WHERE ROWNUM <= 3;

----------------------------------------------------------------

-- 8. WITH
-- 서브쿼리에 이름을 붙여주고 사용 시 이름을 사용하게 함
-- 인라인 뷰로 사용될 서브쿼리에 주로 사용됨
-- 실행속도가 빨라진다는 장점이 있음

-- 전 직원의급여 10 순위
-- 순위, 이름, 급여 조회
WITH TOP_SAL AS
(
SELECT EMP_NAME, SALARY
FROM EMPLOYEE
ORDER BY SALARY DESC
)
SELECT ROW_NUM, EMP_NAME, SALARY
FROM TOP_SAL
WHERE ROWNUM <= 10;
-------------------------------------------------------
-- 9. RANK() OVER/ DENSE_RANK() OVER
-- RANK() OVER : 동일한 순위 이후의 등수를 동일한 인원 수만큼 건너뛰고 순위 계산
-- EX) 공동1위가 2명 다음순위 2위가 아닌 3위


-- 사원별 급여 순위
-- RANK() OVER(정렬 순서) / DENSE_RANK() OVER(정렬순서)

SELECT RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;
-- 19 전형동 2000000
-- 19 윤은해 2000000
-- 21 박나라 1800000

-- DENSE RANK() OVER : 동일한 순위 이후의 등수를 이후 순위로 계산
-- EX) 공동 1위가 2명이어도 다음 순위는 2위

SELECT DENSE_RANK() OVER(ORDER BY SALARY DESC) 순위, EMP_NAME, SALARY
FROM EMPLOYEE;


데이터 무결성 - 제약조건


------------------------연습문제
-- 19 전형동 2000000
-- 19 윤은해 2000000
-- 20 박나라 1800000

--1번

SELECT EMP_ID, EMP_NAME, DEPT_CODE, EMPLOYEE.JOB_CODE, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE, DEPARTMENT, JOB
WHERE EMPLOYEE.DEPT_CODE = DEPARTMENT.DEPT_ID 
AND EMPLOYEE.JOB_CODE = JOB.JOB_CODE
AND (EMPLOYEE.DEPT_CODE, EMPLOYEE.JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
															FROM EMPLOYEE
															WHERE EMP_NAME = '노옹철');


--2번
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, JOB_CODE) = (SELECT DEPT_CODE, JOB_CODE
																FROM EMPLOYEE
																WHERE HIRE_DATE BETWEEN '2000-01-01' AND '2000-12-31');

--3번

SELECT EMP_ID, EMP_NAME, DEPT_CODE, MANAGER_ID, EMP_NO, HIRE_DATE
FROM EMPLOYEE
WHERE (DEPT_CODE, MANAGER_ID) = (SELECT DEPT_CODE, MANAGER_ID
																	FROM EMPLOYEE
																	WHERE EMP_NO LIKE '77%' AND EMP_NO LIKE '_______2%');

--------------------------------------------------------
--06_SUBQUERY_실습문제.pdf

SELECT EMP_ID, EMP_NAME, PHONE, HIRE_DATE, DEPT_ID, DEPARTMENT.DEPT_TITLE 
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_ID = DEPT_CODE
AND DEPT_CODE = ( SELECT DEPT_CODE FROM EMPLOYEE WHERE EMP_NAME = '전지연');