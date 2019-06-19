<%-- 
    Document   : Administrator
    Created on : 31 May, 2019, 3:31:35 PM
    Author     : admin
--%>


<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <link href="https://fonts.googleapis.com/css?family=Roboto:100,300,400,500,700,900|Material+Icons" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.css" rel="stylesheet">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Administrator</title>
    </head>
    <body>
        <div id="add">
            <v-app id="inspire" :dark="dark" >
                <v-toolbar

                    flat
                    >
                    <v-toolbar-title
                        class="tertiary--text font-weight-light"
                        >
                        Cloud-DashBoard
                    </v-toolbar-title>
                    <v-spacer></v-spacer>
                    <v-toolbar-items class="hidden-sm-and-down">
                        <v-btn  @click="dark = !dark" flat>Admnistrator</v-btn>
                    </v-toolbar-items>
                </v-toolbar>
                <v-container wrap>
           
                    <v-container>
                        <v-stepper non-linear >
                            <v-stepper-header>
                                <v-stepper-step
                                    editable
                                    step="1"
                                    >
                                    Add Datacenters
                                </v-stepper-step>

                                <v-divider></v-divider>

                                <v-stepper-step
                                    editable
                                    step="2"
                                    >
                                    Add Users
                                </v-stepper-step>

                                <v-divider></v-divider>

                                <v-stepper-step
                                    step="3"
                                    editable
                                    >
                                    Modify DataCenters
                                </v-stepper-step>
                                <v-divider></v-divider>

                                <v-stepper-step
                                    step="4"
                                    editable
                                    >
                                    Remove Users
                                </v-stepper-step>
                                <v-divider></v-divider>

                                <v-stepper-step
                                    step="5"
                                    editable
                                    >
                                    View Files
                                </v-stepper-step>
                            </v-stepper-header>
                            <v-stepper-items>
                                <v-stepper-content  class="mb-5" step="1">
                                   
                                        <v-form
                                            wrap
                                            lg4
                                            ref="form"
                                            lazy-validation
                                            v-model="valid">                       
                                            <v-text-field
                                                v-model="cid"
                                                label="Data center id"
                                                :rules="[v =>!!v && !ucids.includes(v)|| 'id already present']"
                                                required
                                                ></v-text-field>

                                            <v-text-field
                                                v-model="cname"
                                                label="Name of the data center"
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="csize"
                                                label="Size of the data center"
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="cloc"
                                                label="Location of datacenter"
                                                :rules="[v =>!!v &&!aclocation.includes(v)|| 'Location already present']"
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="cord"
                                                label="Priority of datacenter" 
                                                required
                                                ></v-text-field>
                                            <v-btn
                                                
                                                :disabled="!valid"
                                                name="add"
                                                value="addDatacenter"
                                                color="success"
                                                @click="postData"
                                                >
                                                Add DataCenter
                                            </v-btn>
                                        </v-form> 
                                   
                                </v-stepper-content>

                                <v-stepper-content step="2">
                                   
                                        <v-form
                                            lazy-validation
                                            wrap
                                            lg4
                                            ref="uform"
                                            v-model="uvalid">                       
                                            <v-text-field
                                                v-model="uid"
                                                label="Enter the User id"
                                                  :rules="[v =>!!v && !uuids.includes(v)|| 'User id already present']"
                                                required
                                                ></v-text-field>

                                            <v-text-field
                                                v-model="uname"
                                                label="Name of the User"
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="pass"
                                                label="Create password for user"
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="uloc"
                                                label="Enter the Location of user"
                                                
                                                required
                                                ></v-text-field>
                                            <v-text-field
                                                v-model="ucord"
                                                label="Enter the priority of the user" 
                                                required
                                                ></v-text-field>
                                            <v-btn
                                                :disabled="!uvalid"
                                                name="add"
                                                value="addDatacenter"
                                                color="success"
                                                @click="postUserData"
                                                >
                                                Add DataUser
                                            </v-btn>
                                        </v-form> 
                                  

                                </v-stepper-content>

                                <v-stepper-content step="3">

                                    <v-form v-model="valid" ref="udform" lazy-validation>
                                        <v-container>
                                            <v-layout>
                                                <v-flex
                                                    xs12
                                                    md4
                                                    >
                                                    <v-text-field
                                                        v-model="updatecid"
                                                        label="DataCenter Id"
                                                        :rules="[v =>!!v && ucids.includes(v)|| 'User id not present']"
                                                        required
                                                        ></v-text-field>
                                                </v-flex>

                                                <v-flex
                                                    xs12
                                                    md4
                                                    >
                                                    <v-text-field
                                                        v-model="updatesize"
                                                        type="number"
                                                        :rules="[v =>!!v&&v>0||'cannot be empty']"
                                                        label="Enter the size to increase"
                                                        required
                                                        ></v-text-field>
                                                </v-flex>


                                            </v-layout>
                                        </v-container>
                                         <v-btn
                                        :disabled="!valid"
                                        color="primary"
                                        @click="updateTable()"
                                        >
                                        Update
                                    </v-btn>
                                         <v-btn flat>Cancel</v-btn>
                                    </v-form>
                                   

                                   
                                </v-stepper-content>
                                <v-stepper-content step="4">
                                    <v-form ref="dform">
                                        <v-container>
                                            <v-layout>
                                                <v-flex
                                                    xs12
                                                    md4
                                                    >
                                                    <v-text-field
                                                        v-model="delusers"
                                                        label="User ID"
                                                        :rules="[v =>!!v && uuids.includes(v)|| 'User id not present']"
                                                        required
                                                        ></v-text-field>
                                                </v-flex>
                                            </v-layout>
                                        </v-container>
                                    </v-form>

                                    <v-btn
                                        color="primary"
                                        @click="deleteUsers()"
                                        >
                                        Delete
                                    </v-btn>

                                    <v-btn flat>Cancel</v-btn>
                                </v-stepper-content>
                                <v-stepper-content step="5">
                                    <v-container>
                                        <v-data-table
                                            :headers="fheaders"
                                            :items="finfo"
                                            :key="render"
                                            class="elevation-1"
                                            >
                                            <template v-slot:items="props">

                                                <td>{{ props.item.uid}}</td>
                                                <td >{{ props.item.cid}}</td>
                                                <td>{{ props.item.filename}}</td>
                                                <td>{{ props.item.filesize }}</td>
                                                <td>{{ props.item.type}}</td>

                                            </template>
                                        </v-data-table>
                                    </v-container>

                                </v-stepper-content>
                            </v-stepper-items>
                        </v-stepper>
                    </v-container>
                    <v-container>
                        <v-card>
                            <v-card-title>
                                Data Centers
                                <v-spacer></v-spacer>
                                <v-text-field
                                    append-icon="search"
                                    label="Search"
                                    single-line
                                    hide-details
                                    v-model="csearch"
                                    ></v-text-field>
                            </v-card-title>
                            <v-data-table
                                :headers="headers"
                                :items="info"
                                :key="render"
                                :search="csearch"
                                class="elevation-1"
                                >
                                <template v-slot:items="props">
                                    <tr @click="showClick(props.item)">
                                        <td>{{ props.item.cid }}</td>
                                        <td >{{ props.item.cname}}</td>
                                        <td>{{ props.item.location}}</td>
                                        <td>{{ props.item.size}}</td>
                                        <td>{{ props.item.nof}}</td>
                                    </tr>
                                </template>
                            </v-data-table>
                        </v-card>
                    </v-container>
                     <v-container>
                        <v-card>
                            <v-card-title>
                                User Data
                                <v-spacer></v-spacer>
                                <v-text-field
                                    append-icon="search"
                                    label="Search"
                                    single-line
                                    hide-details
                                    v-model="usearch"
                                    ></v-text-field>
                            </v-card-title>
                            <v-data-table
                                :headers="uheaders"
                                :items="uinfo"
                                :key="render"
                                :search="usearch"
                                class="elevation-1"
                                >
                                <template v-slot:items="props">
                                    <td>{{ props.item.uid}}</td>
                                    <td >{{ props.item.uname}}</td>
                                    <td>{{ props.item.pass}}</td>
                                    <td>{{ props.item.location }}</td>
                                     <td>{{ props.item.nof}}</td>
                                      <td>{{ props.item.size}}</td>
                                </template>
                            </v-data-table>
                        </v-card>
                    </v-container>
                </v-container>
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


            </v-app >

        </div>

    </body>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.6.10/vue.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vuetify/1.5.14/vuetify.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/0.19.0/axios.js"></script>

    <script>
new Vue({el: '#add',

    data() {
        return {
            snackbar: false,
            ucids:[],
            aclocation:[],
            valid: false,
            message: null,
            render: 0,
            dark: false,
            cselected: '',
            csearch: null,
            usearch: null,
            headers: [
                {
                    text: 'Data Center ID',
                    align: 'left',
                    value: 'cid'
                },
                {text: 'Name', value: 'cname'},
                {text: 'Location', value: 'location'},
                {text: 'Size', value: 'size'},
                {text: 'Files', value: 'nof'},
            ],
            uheaders: [
                {
                    text: 'User ID',
                    align: 'left',
                    value: 'uid'
                },
                {text: 'User Name', value: 'uname'},
                {text: 'Password', value: 'pass'},
                {text: 'Location', value: 'location'},
                {text: 'File Count', value: 'nof'},
                {text: 'Size', value: 'size'},
            ],
            fheaders: [
                {
                    text: 'User ID',
                    align: 'left',
                    value: 'uid'
                },
                {text: 'Data Center Id', value: 'cid'},
                {text: 'Filename', value: 'filename'},
                {text: 'File Size', value: 'filesize'},
                {text: 'Type', value: 'type'},
            ],

        };
    },
    methods: {

        async getTable() {
            console.log("insode get table");
            
            await axios.get('/Swift', {
                params: {
                    option: "viewData",
                }
            })
                    .then(response => (this.info = response.data))
                    .catch(function (error) {
                        console.log(error);
                    })
            this.ucids = this.info.map(function (e) {
                return e['cid']
            });
            this.aclocation = this.info.map(function (e) {
                return e['location']
            });
            console.log(this.info);
            console.log(this.aclocation);
            this.render = this.render + 1;


        },
        async getUserTable()
        {
            console.log("user table")
            await axios.get('/User', {
                params: {
                    option: "viewData"
                }
            })
                    .then(response => (this.uinfo = response.data))
                    .catch(function (error) {
                        console.log(error);
                    })
            this.render = this.render + 1;
            this.uuids = this.uinfo.map(function (e) {
                return e['uid']
            });
            console.log("this page uuids")
            console.log(this.uuids)

        },
        async getFileTable()
        {
            await axios.get('/FileView', {
                params: {
                    option: "viewFiles",
                }
            })
                    .then(response => (this.finfo = response.data)
                    )
            this.render = this.render + 1;
            console.log(this.info)

        },
        async postData()
        {
            const params = new URLSearchParams();
            params.append('cid', this.cid);
            params.append('cname', this.cname);
            params.append('csize', this.csize);
            params.append('cloc', this.cloc);
            axios({
                method: 'POST',
                url: '/Swift',
                data: params
            })
                    .then(response => (this.message = "insert successful"))
                    .catch(error => (this.message = "error cannot insert record...inserting Record try again"));
            this.snackbar = true;
            this.$refs.form.reset();
            this.getTable();

        },
        async postUserData()
        {
            const params = new URLSearchParams();
            params.append('uid', this.uid);
            params.append('uname', this.uname);
            params.append('pass', this.pass);
            params.append('uloc', this.uloc);
            params.append('ucord', this.ucord);
            axios({
                method: 'POST',
                url: '/User',
                data: params
            })
                    .then(response => (this.message = "insert successful"))
                    .catch(error => (this.message = "error cannot insert record...inserting Record try again"));
            this.snackbar = true;
            this.$refs.uform.reset();
            this.getUserTable();
        },
        showClick(a)
        {
            this.cselected = a;
        },
        async updateTable()
        {
            await axios.get('/Swift', {
                params: {
                    option: "update",
                    cid: this.updatecid,
                    size: this.updatesize
                }
            })
                    .then(response => this.message = "update successful")
                    .catch(error => this.message = "error during update")
            this.getTable()
            this.$refs.udform.reset();
            this.snackbar = true
        },
        async deleteUsers()
        {
            await axios.get('/User', {
                params: {
                    option: "delete",
                    uid:this.delusers
                }
            })
                    .then(response => (this.message="delete successfull..all the file where deleted"))
                    .catch(function (error) {
                        console.log(error);
                    })
                    this.snackbar="true"
            this.getUserTable();
            this.$refs.dform.reset();
        }

    },
    beforeMount() {
        this.getTable();
        this.getUserTable();
      
    }
});
Vue.use(Vuetify, {
    theme: {
        primary: '#3f51b5',
        secondary: '#b0bec5',
        accent: '#8c9eff',
        error: '#b71c1c'
    }
})
    </script>
</html>
