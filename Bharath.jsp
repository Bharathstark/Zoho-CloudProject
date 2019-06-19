<%-- 
    Document   : index
    Created on : 31 May, 2019, 1:08:38 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.css" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, minimal-ui">
    </head>
    <body>
        <div id="app">
            <v-app id="inspire">
                <v-card flat>
                    <v-toolbar
                        color="primary"
                        dark
                        extended
                        flat
                        >
                    </v-toolbar>

                    <v-layout row pb-2>
                        <v-flex xs8 offset-xs2>
                            <v-card class="card--flex-toolbar">
                                <v-toolbar card prominent>
                                    <v-toolbar-title class="body-2 grey--text">Cloud Storage Simulation</v-toolbar-title>
                                    <v-spacer></v-spacer>
                                </v-toolbar>
                                <v-divider></v-divider>
                                <v-card-text style="height: 200px;">
                                       <v-form class="text-xs-center" action="/Hello">
                                        <v-btn v-model="option" name="option" type="submit" color="success" value="admin">Administrator</v-btn>
                                    </v-form>
                                    <v-spacer></v-spacer>
                                     <v-form class="text-xs-center" action="/Hello">
                                        <v-btn v-model="option" name="option" type="submit" color="success" value="User">User</v-btn>
                                    </v-form>
                                </v-card-text>
                            </v-card>
                        </v-flex>
                    </v-layout>
                </v-card>
            </v-app>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.10/vue.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.0/axios.js"></script>
        <script>
            new Vue({el: '#app',
                data()
                {
                    return{

                    }
                },
                methods: {
                   
                }
            });
            Vue.use(Vuetify, {
                theme: {
                    primary: '#3f51b5',
                    secondary: '#b0bec5',
                    accent: '#8c9eff',
                    error: '#b71c1c'
                }
            });
        </script>
    </body>
</html>