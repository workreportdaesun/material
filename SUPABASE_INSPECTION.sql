-- 자재검수서(inspection.html) 기능에 필요한 material_moves 컬럼 추가.
-- Supabase SQL Editor에서 이 파일 내용을 그대로 실행해주세요.
-- (참고: [[project_material_inspection_report_plan]] 메모리 문서에 설계 배경이 있습니다.)

alter table material_moves add column if not exists supplier text;
alter table material_moves add column if not exists inspector text;
alter table material_moves add column if not exists reject_qty numeric default 0;
alter table material_moves add column if not exists result text;
alter table material_moves add column if not exists photo_urls jsonb default '[]'::jsonb;
