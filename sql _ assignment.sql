#2nd october



SELECT
    gameplay.userid,
    (
        0.01 * COALESCE(deposit.total_deposit, 0)
        + 0.005 * COALESCE(withdrawl.total_withdrawl, 0)
        + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawl.total_withdrawl, 0), 0)
        + 0.2 * COALESCE(gameplay.totalgamesplayed, 0)
    ) AS loyalty_points
FROM
    (
        SELECT
            userid,
            SUM(gamesplayed) AS totalgamesplayed
        FROM
            gameplay
        WHERE
            datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 12:00:00'
        GROUP BY
            userid
    ) AS gameplay
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_deposit
        FROM
            deposit
        WHERE
            datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 12:00:00'
        GROUP BY
            userid
    ) AS deposit ON gameplay.userid = deposit.userid
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_withdrawl
        FROM
            withdrawl
        WHERE
            datetime BETWEEN '2022-10-02 00:00:00' AND '2022-10-02 12:00:00'
        GROUP BY
            userid
    ) AS withdrawl ON gameplay.userid = withdrawl.userid;
--------------------------------------------------------------------------------------------------------------------------------------------------------

16th october slot2

SELECT
    gameplay.userid,
    (
        0.01 * COALESCE(deposit.total_deposit, 0)
        + 0.005 * COALESCE(withdrawl.total_withdrawl, 0)
        + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawl.total_withdrawl, 0), 0)
        + 0.2 * COALESCE(gameplay.totalgamesplayed, 0)
    ) AS loyalty_points
FROM
    (
        SELECT
            userid,
            SUM(gamesplayed) AS totalgamesplayed
        FROM
            gameplay
        WHERE
            datetime BETWEEN '2022-10-16 12:00:00' AND '2022-10-16 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS gameplay
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_deposit
        FROM
            deposit
        WHERE
            datetime BETWEEN '2022-10-16 12:00:00' AND '2022-10-16 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS deposit ON gameplay.userid = deposit.userid
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_withdrawl
        FROM
            withdrawl
        WHERE
            datetime BETWEEN '2022-10-16 12:00:00' AND '2022-10-16 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS withdrawl ON gameplay.userid = withdrawl.userid;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------
18thslot s1

SELECT
    gameplay.userid,
    (
        0.01 * COALESCE(deposit.total_deposit, 0)
        + 0.005 * COALESCE(withdrawl.total_withdrawl, 0)
        + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawl.total_withdrawl, 0), 0)
        + 0.2 * COALESCE(gameplay.totalgamesplayed, 0)
    ) AS loyalty_points
FROM
    (
        SELECT
            userid,
            SUM(gamesplayed) AS totalgamesplayed
        FROM
            gameplay
        WHERE
            datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 12:00:00'
        GROUP BY
            userid
    ) AS gameplay
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_deposit
        FROM
            deposit
        WHERE
            datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 12:00:00'
        GROUP BY
            userid
    ) AS deposit ON gameplay.userid = deposit.userid
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_withdrawl
        FROM
            withdrawl
        WHERE
            datetime BETWEEN '2022-10-18 00:00:00' AND '2022-10-18 12:00:00'
        GROUP BY
            userid
    ) AS withdrawl ON gameplay.userid = withdrawl.userid;
----------------------------------------------------------------------------------------------------


26ocths2
SELECT
    gameplay.userid,
    (
        0.01 * COALESCE(deposit.total_deposit, 0)
        + 0.005 * COALESCE(withdrawl.total_withdrawl, 0)
        + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawl.total_withdrawl, 0), 0)
        + 0.2 * COALESCE(gameplay.totalgamesplayed, 0)
    ) AS loyalty_points
FROM
    (
        SELECT
            userid,
            SUM(gamesplayed) AS totalgamesplayed
        FROM
            gameplay
        WHERE
            datetime BETWEEN '2022-10-26 12:00:00' AND '2022-10-26 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS gameplay
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_deposit
        FROM
            deposit
        WHERE
            datetime BETWEEN '2022-10-26 12:00:00' AND '2022-10-26 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS deposit ON gameplay.userid = deposit.userid
LEFT JOIN
    (
        SELECT
            userid,
            SUM(amount) AS total_withdrawl
        FROM
            withdrawl
        WHERE
            datetime BETWEEN '2022-10-26 12:00:00' AND '2022-10-26 00:00:00' -- Changed datetime range
        GROUP BY
            userid
    ) AS withdrawl ON gameplay.userid = withdrawl.userid;
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
Calculate overall loyalty points earned and rank players on the basis of loyalty points in the month of October. 
     In case of tie, number of games played should be taken as the next criteria for ranking.
SELECT
    userid,
    SUM(loyalty_points) AS overall_loyalty_points,
    SUM(totalgamesplayed) AS total_games_played,
    RANK() OVER (ORDER BY SUM(loyalty_points) DESC, SUM(totalgamesplayed) DESC) AS player_rank
FROM (
    SELECT
        gameplay.userid,
        (
            0.01 * COALESCE(deposit.total_deposit, 0)
            + 0.005 * COALESCE(withdrawal.total_withdrawal, 0)
            + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawal.total_withdrawal, 0), 0)
            + 0.2 * COALESCE(gameplay.totalgamesplayed, 0)
        ) AS loyalty_points,
        COALESCE(gameplay.totalgamesplayed, 0) AS totalgamesplayed
    FROM
        gameplay
    LEFT JOIN (
        SELECT userid, SUM(amount) AS total_deposit
        FROM deposit
        WHERE EXTRACT(MONTH FROM datetime) = 10
        GROUP BY userid
    ) AS deposit ON gameplay.userid = deposit.userid
    LEFT JOIN (
        SELECT userid, SUM(amount) AS total_withdrawal
        FROM withdrawal
        WHERE EXTRACT(MONTH FROM datetime) = 10
        GROUP BY userid
    ) AS withdrawal ON gameplay.userid = withdrawal.userid
    WHERE EXTRACT(MONTH FROM gameplay.datetime) = 10
) AS loyalty_data
GROUP BY userid;


-----------------------------------------------------------------------------------------------------------------------------------------------------------

 What is the average deposit amount?
SELECT AVG(amount) AS average_deposit_amount
FROM deposit;
---------------------------------------------------------------------------------------------------------------------
 What is the average deposit amount per user in a month?

SELECT
    userid,
    AVG(amount) AS average_deposit_amount_per_user
FROM
    deposit
WHERE
    EXTRACT(MONTH FROM datetime) = <month_number>
GROUP BY
    userid;
---------------------------------------------------------------------------------------------------------------------------------------------------
What is the average number of games played per user?


SELECT AVG(gamesplayed) AS average_games_played_per_user
FROM (
    SELECT userid, SUM(gamesplayed) AS gamesplayed
    FROM gameplay
    GROUP BY userid
) AS user_games;
------------------------------------------------------------------------------------------------------------------------------------------------------------
After calculating the loyalty points for the whole month find out which 50 players are at the top of the leaderboard. The company has allocated a pool of Rs 50000 to be given away as bonus money to the loyal players.


WITH RankedPlayers AS (
    SELECT
        userid,
        SUM(loyalty_points) AS total_loyalty_points,
        RANK() OVER (ORDER BY SUM(loyalty_points) DESC) AS player_rank
    FROM (
        -- Calculate loyalty points for the entire month
        SELECT
            gameplay.userid,
            (
                0.01 * COALESCE(deposit.total_deposit, 0)
                + 0.005 * COALESCE(withdrawl.total_withdrawl, 0)
                + 0.001 * GREATEST(COALESCE(deposit.total_deposit, 0) - COALESCE(withdrawl.total_withdrawl, 0), 0)
                + 0.2 * COALESCE(gameplay.gamesplayed, 0)
            ) AS loyalty_points
        FROM
            gameplay
        LEFT JOIN (
            SELECT userid, SUM(amount) AS total_deposit
            FROM deposit
            GROUP BY userid
        ) AS deposit ON gameplay.userid = deposit.userid
        LEFT JOIN (
            SELECT userid, SUM(amount) AS total_withdrawl
            FROM withdrawl
            GROUP BY userid
        ) AS withdrawl ON gameplay.userid = withdrawl.userid
    ) AS loyalty_data
    GROUP BY userid
)
SELECT
    userid,
    total_loyalty_points,
    RANK() OVER (ORDER BY total_loyalty_points DESC) AS player_rank,
    ROUND(
        CASE
            WHEN player_rank <= 50 THEN 50000 * total_loyalty_points / (SELECT SUM(total_loyalty_points) FROM RankedPlayers WHERE player_rank <= 50)
            ELSE 0
        END
    ) AS bonus_money
FROM
    RankedPlayers
WHERE
    player_rank <= 50;