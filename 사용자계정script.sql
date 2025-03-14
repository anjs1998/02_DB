-- 한줄 주석

/**
 * 범위주석
 * 
 * 
 */

ALTER SESSION SET "_ORACLE_SCRIPT" = TRUE; -- 12c버전 이전 문법 허용 구문 
CREATE USER workbook IDENTIFIED BY workbook; -- 계정 생성 구문(username : kh / pw : kh1234)



GRANT RESOURCE, CONNECT TO workbook; -- 사용자 계정 권한 부여 설정
-- RESOURCE : 테이블이나 인덱스 같은 DB객체를 생성할 권한
-- CONNECT : DB에 연결하고 로그인할수 있는 권한

ALTER USER workbook DEFAULT TABLESPACE SYSTEM QUOTA UNLIMITED ON SYSTEM ;
-- 객체가 생성될수 있는 공간 할당량 무제한 지정

--선택한 SQL 수행 : 구문에 커서 두고 CTRL + ENTER
-- 전체 SQL 수행 : 전체 구문을 활성화 시킨채로 alt + x