-- ====================================================================
-- SCRIPT CẤP TOÀN QUYỀN ĐỌC/GHI/SỬA/XÓA (CRUD) & TẮT RLS TRÊN SUPABASE
-- CHẠY SCRIPT NÀY TRONG SUPABASE SQL EDITOR ĐỂ APP KẾT NỐI & THAO TÁC 100%
-- ====================================================================

-- 1. CẤP QUYỀN TRUY CẬP SCHEMA & TOÀN BỘ BẢNG CHO ROLE 'anon' VÀ 'authenticated'
-- Cho phép đọc (SELECT), ghi mới (INSERT), cập nhật (UPDATE), xóa (DELETE)
GRANT USAGE ON SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL TABLES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO anon, authenticated, service_role;
GRANT ALL ON ALL ROUTINES IN SCHEMA public TO anon, authenticated, service_role;

-- Áp dụng quyền tự động cho các bảng/sequence tạo trong tương lai
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO anon, authenticated, service_role;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON ROUTINES TO anon, authenticated, service_role;

-- 2. TỰ ĐỘNG TẮT ROW LEVEL SECURITY (RLS) CHO TOÀN BỘ CÁC BẢNG TRONG SCHEMA PUBLIC
-- (Giúp App Flutter ghi trực tiếp và thay đổi trực tiếp mà không bị chặn bởi bất kỳ Policy nào)
DO $$ 
DECLARE 
    r RECORD;
BEGIN 
    FOR r IN (SELECT tablename FROM pg_tables WHERE schemaname = 'public') 
    LOOP 
        EXECUTE 'ALTER TABLE public.' || quote_ident(r.tablename) || ' DISABLE ROW LEVEL SECURITY;';
    END LOOP; 
END $$;

-- 3. CHÈN DỮ LIỆU MẪU BAN ĐẦU (NẾU CHƯA CÓ)
-- A. Khóa học mẫu (Courses)
INSERT INTO public.courses (id, title, description, level, total_lessons, category, is_published, created_at)
VALUES 
  ('c1010000-0000-0000-0000-000000000001', 'Tiếng Anh Giao Tiếp Cơ Bản', 'Khóa học dành cho người mới bắt đầu luyện giao tiếp hằng ngày.', 'Beginner', 10, 'Communication', true, NOW()),
  ('c1020000-0000-0000-0000-000000000002', 'Luyện Thi TOEIC 650+ Cấp Tốc', 'Phương pháp ôn luyện TOEIC 4 kỹ năng chuẩn hóa với AI.', 'Intermediate', 15, 'Exam', true, NOW()),
  ('c1030000-0000-0000-0000-000000000003', 'Từ Vựng IELTS Band 7.0+', 'Tổng hợp từ vựng Academic và Collocations nâng cao.', 'Advanced', 20, 'IELTS', true, NOW())
ON CONFLICT (id) DO NOTHING;

-- B. Bộ thẻ mẫu (Decks)
INSERT INTO public.decks (id, title, description, category, total_cards, is_public, created_at)
VALUES 
  ('d1010000-0000-0000-0000-000000000001', '300 Từ Vựng TOEIC Thông Dụng', 'Bộ từ vựng kinh doanh và văn phòng cốt lõi.', 'TOEIC', 300, true, NOW()),
  ('d1020000-0000-0000-0000-000000000002', '500 Từ IELTS Speaking Part 1 & 2', 'Bộ thẻ mẫu từ vựng nói tự nhiên với phát âm chuẩn.', 'IELTS', 500, true, NOW()),
  ('d1030000-0000-0000-0000-000000000003', 'Từ Vựng Tiếng Anh Du Lịch', 'Các câu và từ vựng khi đi sân bay, khách sạn, nhà hàng.', 'Travel', 150, true, NOW())
ON CONFLICT (id) DO NOTHING;

-- C. Thẻ Flashcard mẫu (Flashcards)
INSERT INTO public.flashcards (id, deck_id, word, phonetic, definition_vi, definition_en, example_en, example_vi, created_at)
VALUES 
  ('f1010000-0000-0000-0000-000000000001', 'd1010000-0000-0000-0000-000000000001', 'Accommodate', '/əˈkɒm.ə.deɪt/', 'Cung cấp chỗ ở, đáp ứng yêu cầu', 'To provide with a place to live or to be given what is needed', 'The hotel can accommodate up to 500 guests.', 'Khách sạn có thể cung cấp chỗ ở cho tối đa 500 khách.', NOW()),
  ('f1020000-0000-0000-0000-000000000002', 'd1010000-0000-0000-0000-000000000001', 'Negotiate', '/nəˈɡəʊ.ʃi.eɪt/', 'Đàm phán, thương lượng', 'To try to reach an agreement by formal discussion', 'We need to negotiate the terms of the contract.', 'Chúng ta cần thương lượng các điều khoản hợp đồng.', NOW())
ON CONFLICT (id) DO NOTHING;
