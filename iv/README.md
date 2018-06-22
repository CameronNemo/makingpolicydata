topic: iv
desc: instrumental variables estimation

# iv

**Instrumental variables estimation** is useful when at least one OLS regressor is correlated with the error term (see topic "bias").

## Conditions

A good instrumental variable (iv) has two qualities:

 * relevance
 * exogeneity

**relevance** consists of a strong first stage. This occurs when the correlation between the iv and the biased OLS regressor is non-zero and strong. A weak correlation can lead to misleading parameter estimates and standard errors in the second stage.

For the linear model,

        y = 0 + x + w + u

where `0` represents the constant,

`u` the error term,

`x` the endogenous (biased) regressor terms,

        corr(x, u) != 0

and `w` the exogenous (unbiased) regressor terms.

        corr(w, u) == 0

A relevant `iv` must be correlated with `x`,

        corr(x, iv) != 0

and this correlation must be *strong*.

**exogeniety** exists when the `iv` is not correlated with the error term:

        corr(iv, u) == 0

In other words, the `iv` must not suffer from the same issue as the biased OLS regressor, `x`.

### identification

Given the number of instruments (`m`) and the number of endogenous regressors (`k`) in a model,

 * if `m < k`, the model is underidentified and tsls cannot be used (see section "Estimation").
 * if `m > k`, the model is overidentified. tsls can be used, and exogeniety can be tested (see section "Hypothesis Testing").
 * if `m == k`, the model is exactly identified. tsls can be used, but exogeneity cannot be tested.

## Estimation

**two stage least squares (tsls, 2sls)** is used for estimation.

In the *first stage*, the linear model:

        x = 0 + iv + w + v

where `v` represents the error term,

and `0` the constant,

generates the predicted value `x_hat`.

The *second stage* replaces the biased terms with the predicted value in the original linear model:

        y = 0 + x_hat + w + u

### Stata examples

Manual tsls:

        reg x iv w, robust
        predict x_hat, xb
        reg y x_hat w, robust

Stata provided command:

        ivregress 2sls y (x = iv) w, small robust

`small` option makes adjustments to degrees of freedom for small samples.

## Interpretation

(see topic ols)

Misleading interpretations can be made if the first stage is weak, or if the `iv` is not actually exogenous.

## Hypothesis testing

Testing relevance uses an F test for the first stage regression, with the null hypothesis that the `iv` coefficients equal zero.

*rule of thumb*: an f-stat > 10 denotes a strong instrument

The test for exogeneity is called a **J-test**.

*note*: testing exogeneity requires overidentification (see section "Conditions:identification")

This test uses the following model:

        u = 0 + iv + w + e

where `u` represents the error term from the second stage tsls estimation, `e` is the error term for this model, and `0` is the constant.

An F test is conducted with the null hypothesis that `iv` coefficients equal zero.

The **J-stat** takes the value `mF` and has a chi-square distribution with `m - k` degrees of freedom. Recall that `m` represents number of instruments and `k` the number of endogenous regressors. Rejecting the null (J-stat > critical value) provides evidence against exogeneity.

### Stata examples

Testing relevance:

        reg x iv w, robust
        test iv

Testing exogeneity with two instrumental variables and one endogenous variable:

        ivregress 2sls y (x = iv1 iv2) w, small robust
        predict e, residuals
          reg e iv1 iv2 w
          test iv1 iv2
          di "J-stat: " r(df)*r(F) " p-value: " chiprob(r(df)-1,r(df)*r(F))
        drop e
