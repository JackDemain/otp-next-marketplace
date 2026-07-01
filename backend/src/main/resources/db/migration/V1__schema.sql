-- V1__schema.sql — OTP NEXT MVP0 schema
-- 4 таблицы: categories, products, orders, order_items
-- Статусы orders: только 'pending' и 'cancelled' (MVP0 minimum)

-- ============================================================================
-- categories
-- ============================================================================
CREATE TABLE categories (
    id            BIGSERIAL PRIMARY KEY,
    okved_code    VARCHAR(20) NOT NULL,
    name          VARCHAR(255) NOT NULL,
    sort_order    INT NOT NULL DEFAULT 0,
    is_active     BOOLEAN NOT NULL DEFAULT TRUE,
    created_at    TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_categories_active ON categories(is_active, sort_order);

-- ============================================================================
-- products
-- ============================================================================
CREATE TABLE products (
    id             BIGSERIAL PRIMARY KEY,
    category_id    BIGINT NOT NULL REFERENCES categories(id),
    name           VARCHAR(255) NOT NULL,
    description    TEXT,
    sku            VARCHAR(50),
    price          DECIMAL(15,2) NOT NULL CHECK (price >= 0),
    currency       VARCHAR(3) NOT NULL DEFAULT 'RUB',
    unit           VARCHAR(20) NOT NULL DEFAULT 'шт',
    min_order_qty  INT NOT NULL DEFAULT 1 CHECK (min_order_qty > 0),
    stock_qty      INT NOT NULL DEFAULT 0 CHECK (stock_qty >= 0),
    supplier_name  VARCHAR(255),
    image_url      VARCHAR(500),
    is_active      BOOLEAN NOT NULL DEFAULT TRUE,
    created_at     TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at     TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_products_category ON products(category_id, is_active);
CREATE INDEX idx_products_active ON products(is_active);
-- ILIKE поиск по name — trigram-индекс не ставим (MVP0), full-scan приемлем при ~80 товарах
CREATE INDEX idx_products_name_lower ON products(LOWER(name));

-- ============================================================================
-- orders
-- ============================================================================
CREATE TABLE orders (
    id                BIGSERIAL PRIMARY KEY,
    external_id       VARCHAR(20) NOT NULL UNIQUE,
    total_amount      DECIMAL(15,2) NOT NULL CHECK (total_amount >= 0),
    currency          VARCHAR(3) NOT NULL DEFAULT 'RUB',
    status            VARCHAR(20) NOT NULL DEFAULT 'pending'
                      CHECK (status IN ('pending', 'cancelled')),
    delivery_address  TEXT,
    comment           TEXT,
    created_at        TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at        TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_orders_status ON orders(status, created_at DESC);
CREATE INDEX idx_orders_created ON orders(created_at DESC);

-- ============================================================================
-- order_items — снэпшот цен на момент заказа
-- ============================================================================
CREATE TABLE order_items (
    id           BIGSERIAL PRIMARY KEY,
    order_id     BIGINT NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id   BIGINT NOT NULL REFERENCES products(id),
    product_name VARCHAR(255) NOT NULL,  -- снэпшот на момент заказа
    quantity     INT NOT NULL CHECK (quantity > 0),
    unit_price   DECIMAL(15,2) NOT NULL CHECK (unit_price >= 0),  -- снэпшот цены
    total_price  DECIMAL(15,2) NOT NULL CHECK (total_price >= 0)  -- quantity * unit_price
);

CREATE INDEX idx_order_items_order ON order_items(order_id);
CREATE INDEX idx_order_items_product ON order_items(product_id);
