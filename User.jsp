<%-- 
    Document   : User
    Created on : 3 Jun, 2019, 1:19:29 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.css" rel="stylesheet">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body >
        <div id ="app">
            <template>
                <v-app :dark="dark">
                    <v-toolbar
                        flat
                        >
                        <v-toolbar-title
                            class="tertiary--text font-weight-light"
                            >
                            Cloud-User-DashBoard
                        </v-toolbar-title>
                        <v-spacer></v-spacer>
                        <v-toolbar-items class="hidden-sm-and-down">
                            <v-btn @click="dark = !dark" @click.right.prevent="logout()" flat>{{badge}}</v-btn>
                        </v-toolbar-items>
                    </v-toolbar>
                    <div class="text-xs-center">
                        <v-dialog
                            v-model="dialog"
                            persistent
                            width="500"
                            >
                            <v-form>
                                <v-card>
                                    <v-container>
                                        <v-text-field
                                            v-model="user"
                                            label="UserID"
                                            single-line
                                            outline
                                            >

                                        </v-text-field>

                                        <v-text-field
                                            v-model="password"
                                            type="password"
                                            label="Password"
                                            hint="At least 8 characters"
                                            single-line
                                            outline
                                            ></v-text-field>

                                        <v-card-actions>
                                            <v-spacer></v-spacer>
                                            <v-btn
                                                v-model="option"
                                                color="primary"
                                                flat
                                                value="user"
                                                @click="verifyLog"
                                                >
                                                Login
                                            </v-btn>
                                        </v-card-actions>
                                    </v-container>
                                </v-card>
                            </v-form>
                        </v-dialog>
                    </div>
                    <v-snackbar
                        v-model='snackbar'
                        :top=true
                        >
                        {{message}}
                        <v-btn
                            color="pink"
                            flat
                            @click="snackbar = false"
                            >
                            Close
                        </v-btn>
                    </v-snackbar> 
                    <v-container>
                        <v-container>
                            <v-card>
                                <v-card-title>
                                    FileData
                                    <v-spacer></v-spacer>
                                    <v-text-field
                                        append-icon="search"
                                        label="Search"
                                        single-line
                                        hide-details
                                        v-model="filename"
                                        ></v-text-field>
                                </v-card-title>
                                <v-data-table
                                    :headers="headers"
                                    :key="r"
                                    :items="info"
                                    :search="filename"
                                    class="elevation-1"
                                    >
                                    <template v-slot:items="props">
                                        <tr @click="fselected=props.item" @dblclick="ReadFile()">
                                            <td>{{ props.item.fileid }}</td>
                                            <td >{{ props.item.filename}}</td>
                                            <td>{{ props.item.filesize}}</td>
                                        </tr>
                                    </template>
                                </v-data-table>
                            </v-card>
                        </v-container>   
                        <v-container>
                            <v-stepper non-linear >
                                <v-stepper-header>
                                    <v-stepper-step
                                        editable
                                        step="1"
                                        >
                                        Add Files
                                    </v-stepper-step>

                                    <v-divider></v-divider>
                                    <v-stepper-step
                                        editable
                                        step="2"
                                        >
                                        Remove Files
                                    </v-stepper-step>

                                    <v-divider></v-divider>

                                    <v-stepper-step
                                        step="3"
                                        editable
                                        >
                                        Download File
                                    </v-stepper-step>
                                    <v-divider></v-divider>
                                </v-stepper-header>
                                <v-stepper-items>
                                    <v-stepper-content  class="mb-5" step="1">
                                        <v-card >
                                            <v-form  ref="form"  enctype = "multipart/form-data">
                                                <input type="file" id="files"  ref="files" v-on:change="handleFilesUploads()"/>
                                                <v-btn
                                                    @click="submitFile()"
                                                    color="blue-grey"
                                                    class="white--text"
                                                    >
                                                    Upload
                                                    <v-icon right dark>cloud_upload</v-icon>
                                                </v-btn>
                                            </v-form>
                                        </v-card>
                                    </v-stepper-content>

                                    <v-stepper-content step="2">
                                        <v-card>
                                            <v-form lazy-validation>
                                                <v-autocomplete
                                                    v-model="delfile"
                                                    :items="ufids"
                                                    label="Enter the filename"
                                                    :rules="[v =>!!v && ufids.includes(v)|| 'File not present']"
                                                    required
                                                    ></v-autocomplete>

                                                <v-btn
                                                    @click="RemoveFile()"
                                                    color="blue-grey"
                                                    class="white--text"
                                                    >
                                                    Remove file
                                                    <v-icon right dark>delete</v-icon>
                                                </v-btn>
                                            </v-form>
                                        </v-card>

                                    </v-stepper-content>

                                    <v-stepper-content step="3">
                                        <v-card>
                                            <v-text-field
                                                ref="readfile"
                                                v-bind:value="fselected.fileid"
                                                label="Enter the fileid"
                                                :rules="[v =>!!v && ufids.includes(v)|| 'File not present']"
                                                required
                                                ></v-text-field>
                                            <v-btn
                                                ref="readfilename"
                                                @click="ReadFile()"
                                                v-bind:value="fselected.filename"
                                                color="blue-grey"
                                                class="white--text"
                                                >
                                                Read file
                                            </v-btn>

                                        </v-card>


                                    </v-stepper-content>
                                </v-stepper-items>
                            </v-stepper>
                        </v-container>
                    </v-container>
                </v-app>
            </template>
        </div>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.10/vue.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.0/axios.js"></script>
        <script>
var size;
var content;
var filename;
new Vue({el: '#app',
    data() {
        return {
            dialog: true,
            fselected: [],
            user: '',
            badge: "User",
            snackbar: false,
            dark: false,
            r: 1,
            model: null,
            info: null,
            filename: null,
            delfile: '',
            headers: [
                {
                    text: 'File ID',
                    align: 'left',
                    value: 'fileid'
                },
                {text: 'File Name', value: 'filename'},
                {text: 'File Size', value: 'filesize'}
            ],
        }
    }, methods: {
        async verifyLog()
        {
            console.log("second");
            axios.get('/User', {
                params: {
                    ID: this.user,
                    PASS: this.password,
                    option: "verifyLog"
                }
            })
                    .then(response => (this.verifyData(response.data))
                    )
                    .catch(function (error) {
                        console.log(error);
                    })
                    .then(function () {
                        // always executed
                    });
        },
        verifyData(data)
        {
            if (data.VAL == "SUCCESS")
            {
                this.getTable();
                this.dialog = false;
                this.badge = this.user;
            } else if (data.VAL == "FAILURE")
            {
                this.snackbar = true;
                this.message = "invalid credentials"
            }
        },
        handleFilesUploads() {
            this.files = this.$refs.files.files;
            var f = this.files[0];
            filename = f.name;
            size = Math.ceil(f.size / 1024);
            console.log(f.size)
            var reader = new FileReader();
            reader.onload = function (e) {
                console.log(e.target.result)
                content = new TextDecoder("utf-8").decode(new Uint8Array(e.target.result));
                console.log(content)
            }
            reader.readAsArrayBuffer(f);

        },
        submitFile()
        {
            console.log(size)
                const params = new URLSearchParams();
                params.append('uid', this.user);
                params.append('fname', filename);
                params.append('fsize', size);
                params.append('file', content);
                axios({
                    method: 'POST',
                    url: '/FileUpload',
                    data: params
                })
                        .then(response => (this.message = "insert successful"))
                        .catch(error => (this.message = "error cannot insert record...inserting Record try again"));
                this.snackbar = true
            

            this.getTable()
            this.$refs.files.value = null;

        },
        async RemoveFile()
        {
            await axios.get('/FileUpload', {
                params: {
                    option:"delete",
                    uid: this.user,
                    fileid: this.delfile
                }
            })
                    .then(response => (this.message = "delete successfull..all the file where deleted"))
                    .catch(function (error) {
                        console.log(error);
                    })
            this.snackbar = true;
            this.getTable();
            this.$refs.delfile.reset();


        },
        async ReadFile()
        {
            await axios.get('/FileUpload', {
                params: {
                    option: "download",
                    FILE: this.$refs.readfile.value
                }
            })
                    .then(response => (this.FileDownload(response))
                    )

        },
        async getTable()
        {
            console.log("table")
            await axios.get('/FileUpload', {
                params: {
                    option: "viewDataUser",
                    ID: this.user
                }
            })
                    .then(response => (this.info = response.data)
                    )
            this.r = this.r + 1;
            this.ufids = this.info.map(function (e) {
                return e['fileid']
            });
            console.log(this.ufids)
        },
        FileDownload(response) {
            console.log("response")
            console.log(response.data)
            const url = window.URL.createObjectURL(new Blob([response.data]))
            const link = document.createElement('a')
            link.href = url
            link.setAttribute('download', this.$refs.readfilename.value) //or any other extension
            document.body.appendChild(link)
            link.click()
        },
        readCookie(name) {
            var key = name + "=";
            var cookies = document.cookie.split(';');
            for (var i = 0; i < cookies.length; i++) {
                var cookie = cookies[i];
                while (cookie.charAt(0) === ' ') {
                    cookie = cookie.substring(1, cookie.length);
                }
                if (cookie.indexOf(key) === 0) {
                    return cookie.substring(key.length, cookie.length);
                }
            }
            return null;
        },
        checkCookie()
        {
            if (this.readCookie("user") != null)
            {
                this.user = this.readCookie("user");
                this.badge = this.user;
                this.dialog = false;
                this.getTable();
            }
        },
        logout()
        {
            this.user = null;
            this.badge = "User";
            this.createCookie("user","",-1);
            this.getTable();
            this.dialog = true;
        },
        createCookie(key,value,date) {
            var expiration = new Date(date).toUTCString();
           document.cookie = escape(key) + "=" + escape(value) + ";Expires=" +expiration+ ";Path=/";
            console.log("canceling cookie...")
            
        }

    },
    beforeMount()
    {
        this.checkCookie();
    }

})
Vue.use(Vuetify, {
    theme: {
        secondary: '#b0bec5',
        accent: '#8c9eff',
        error: '#b71c1c'
    }
})
        </script>
    </body>
</html>
