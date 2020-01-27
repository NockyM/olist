drop table IF EXISTS dbo.orders_reviews;
GO

create table orders_reviews(        
    review_id varchar(32) NOT NULL,       
    order_id varchar(32) NULL, 
    review_score int NULL,
    review_comment_title varchar(32) NULL,
    review_comment_message NVARCHAR(max) NULL,
    review_creation_date datetime NULL,
    review_answer_timestamp datetime NULL
);  
GO

drop PROCEDURE IF EXISTS [dbo].[spOverwriteOrderReviews];
GO

drop type IF EXISTS [dbo].[OrderReviewsType];
GO

CREATE TYPE [dbo].[OrderReviewsType] AS TABLE(
    review_id varchar(32) NOT NULL,       
    order_id varchar(32) NULL, 
    review_score int NULL,
    review_comment_title varchar(32) NULL,
    review_comment_message NVARCHAR(max) NULL,
    review_creation_date datetime NULL,
    review_answer_timestamp datetime NULL
)
GO

CREATE PROCEDURE [dbo].[spOverwriteOrderReviews] @OrderReviews dbo.OrderReviewsType READONLY
    AS
    SET NOCOUNT ON

    BEGIN
    MERGE dbo.orders_reviews AS target
    USING (Select review_id, order_id, review_score, review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp from @OrderReviews) AS source
            (review_id,	order_id, review_score,	review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
    ON (target.review_id       = source.review_id AND
        target.order_id        = source.order_id
        )
    WHEN MATCHED THEN
        UPDATE SET 
        review_id = source.review_id,
        order_id = source.order_id,
        review_score = source.review_score,
        review_comment_title = source.review_comment_title,
        review_comment_message = source.review_comment_message,
        review_creation_date = source.review_creation_date,
        review_answer_timestamp = source.review_answer_timestamp
    WHEN NOT MATCHED THEN
        INSERT (review_id,	order_id, review_score,	review_comment_title, review_comment_message, review_creation_date, review_answer_timestamp)
        VALUES (source.review_id, source.order_id, source.review_score, source.review_comment_title, source.review_comment_message, source.review_creation_date, source.review_answer_timestamp);
    END
    SET NOCOUNT OFF
GO