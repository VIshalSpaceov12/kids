/**
 * Creates a Joi validation middleware.
 * Validates req.body against the provided Joi schema.
 * Returns 400 with detailed errors if validation fails.
 *
 * @param {import('joi').ObjectSchema} schema - Joi validation schema
 * @returns {Function} Express middleware
 */
function validate(schema) {
  return (req, res, next) => {
    const { error, value } = schema.validate(req.body, {
      abortEarly: false,
      stripUnknown: true,
    });

    if (error) {
      const errors = error.details.map((detail) => ({
        field: detail.path.join('.'),
        message: detail.message,
      }));

      return res.status(400).json({
        success: false,
        message: 'Validation failed',
        errors,
      });
    }

    // Replace body with validated and sanitized value
    req.body = value;
    next();
  };
}

module.exports = validate;
