import React from "react";
import {
  Formik,
  Form,
  Field
} from "formik";

interface RegistrationFormValues {
  email: string
}

const Register = () => {
  const initialValues: RegistrationFormValues = { email: '' };

  return (
    <Formik
      initialValues={initialValues}
      validate={(values: RegistrationFormValues) => {
        const errors: { email: string | null } = { email: null };
        if (!values.email) {
          errors.email = 'Required';
        } else if (
          !/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i.test(values.email)
        ) {
          errors.email = 'Invalid email address';
        }
        return errors;
      }}
      onSubmit={(values: RegistrationFormValues, actions: any) => {
        console.log({ values, actions });
        alert(JSON.stringify(values, null, 2));
        actions.setSubmitting(false);
      }}
    >
      <Form>
        <label htmlFor="email">Email</label>
        <Field id="email" name="email" placeholder="Email" />
        <button type="submit">Submit</button>
      </Form>
    </Formik >
  );
};

export default Register;