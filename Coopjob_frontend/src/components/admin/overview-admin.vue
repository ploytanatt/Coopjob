<template>
    <div class="container">
        <main class="column">
      <div class="level">
        <div class="level-left">
          <div class="level-item">
            <div class="title">Overview</div>
          </div>
        </div>
        <div class="level-right">
          <div class="level-item">
            <button type="button" class="button is-small">
              March 8, 2017 - April 6, 2017
            </button>
          </div>
        </div>
      </div>
      
      <div class="columns is-multiline">
        <div class="column">
          <div class="box">
            <div class="heading">Top Seller Total</div>
            <div class="title">56,950</div>
            <div class="level">
              <div class="level-item">
                <div class="">
                  <div class="heading">Sales $</div>
                  <div class="title is-5">250,000</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Overall $</div>
                  <div class="title is-5">750,000</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Sales %</div>
                  <div class="title is-5">25%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="box">
            <div class="heading">Revenue / Expenses</div>
            <div class="title">55% / 45%</div>
            <div class="level">
              <div class="level-item">
                <div class="">
                  <div class="heading">Rev Prod $</div>
                  <div class="title is-5">30%</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Rev Serv $</div>
                  <div class="title is-5">25%</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Exp %</div>
                  <div class="title is-5">45%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="box">
            <div class="heading">Feedback Activity</div>
            <div class="title">78% &uarr;</div>
            <div class="level">
              <div class="level-item">
                <div class="">
                  <div class="heading">Positive</div>
                  <div class="title is-5">1560</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Negative</div>
                  <div class="title is-5">368</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Pos/Neg %</div>
                  <div class="title is-5">77% / 23%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="column">
          <div class="box">
            <div class="heading">Orders / Returns</div>
            <div class="title">75% / 25%</div>
            <div class="level">
              <div class="level-item">
                <div class="">
                  <div class="heading">Orders $</div>
                  <div class="title is-5">425,000</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Returns $</div>
                  <div class="title is-5">106,250</div>
                </div>
              </div>
              <div class="level-item">
                <div class="">
                  <div class="heading">Success %</div>
                  <div class="title is-5">+ 28,5%</div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="columns is-multiline">
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">
              Expenses: Daily - $700
            </p>
            <Bar
    id="my-chart-id"
    :options="chartOptions"
    :data="chartData"
  />
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">
              Refunds: Daily - $200
            </p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720">
              </figure>
            </div>
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">
              Something
            </p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720">
              </figure>
            </div>
          </div>
        </div>
        <div class="column is-6">
          <div class="panel">
            <p class="panel-heading">
              Something Else
            </p>
            <div class="panel-block">
              <figure class="image is-16x9">
                <img src="https://placehold.it/1280x720">
              </figure>
            </div>
          </div>
        </div>
      </div>
    </main>
        <div class="columns">
            <div class="column is-9">
                <section class="hero is-info welcome is-small">
                    <div class="hero-body">
                        <div class="container">
                            <h1 class="title">
                                Hello, Admin.
                            </h1>
                            <h2 class="subtitle">
                                I hope you are having a great day!
                            </h2>
                        </div>
                    </div>
                </section>
                <section class="info-tiles">
                    <div class="tile is-ancestor has-text-centered">
                        <div class="tile is-parent">
                            <article class="tile is-child box">
                                <p class="title">439k</p>
                                <p class="subtitle">Users</p>
                            </article>
                        </div>
                        <div class="tile is-parent">
                            <article class="tile is-child box">
                                <p class="title">59k</p>
                                <p class="subtitle">Products</p>
                            </article>
                        </div>
                        <div class="tile is-parent">
                            <article class="tile is-child box">
                                <p class="title">3.4k</p>
                                <p class="subtitle">Open Orders</p>
                            </article>
                        </div>
                        <div class="tile is-parent">
                            <article class="tile is-child box">
                                <p class="title">19</p>
                                <p class="subtitle">Exceptions</p>
                            </article>
                        </div>
                    </div>
                </section>
                <div class="columns">
                    <div class="column is-6">
                        <div class="card events-card">
                            <header class="card-header">
                                <p class="card-header-title">
                                    Events
                                </p>
                                <a href="#" class="card-header-icon" aria-label="more options">
                  <span class="icon">
                    <i class="fa fa-angle-down" aria-hidden="true"></i>
                  </span>
                </a>
                            </header>
                            <div class="card-table">
                                <div class="content">
                                    <table class="table is-fullwidth is-striped">
                                        <tbody>
                                            <tr>
                                                <td width="5%"><i class="fa fa-bell-o"></i></td>
                                                <td>Lorum ipsum dolem aire</td>
                                                <td class="level-right"><a class="button is-small is-primary" href="#">Action</a></td>
                                            </tr>
                                            <tr>
                                                <td width="5%"><i class="fa fa-bell-o"></i></td>
                                                <td>Lorum ipsum dolem aire</td>
                                                <td class="level-right"><a class="button is-small is-primary" href="#">Action</a></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                            <footer class="card-footer">
                                <a href="#" class="card-footer-item">View All</a>
                            </footer>
                        </div>
                    </div>
                    <div class="column is-6">
                        <div class="card">
                            <header class="card-header">
                              <p class="card-header-title">
                                  Inventory Search
                              </p>
                              <a href="#" class="card-header-icon" aria-label="more options">
                                <span class="icon">
                                  <i class="fa fa-angle-down" aria-hidden="true"></i>
                                </span>
                              </a>
                            </header>
                            <div class="card-content">
                                <div class="content">
                                    <div class="control has-icons-left has-icons-right">
                                      <input class="input is-large" type="text" placeholder="">
                                      <span class="icon is-medium is-left">
                                        <i class="fa fa-search"></i>
                                      </span>
                                      <span class="icon is-medium is-right">
                                        <i class="fa fa-check"></i>
                                      </span>
                                    </div>
                                </div>
                            </div>
                            <Bar id="my-chart-id"
                                :options="chartOptions"
                                :data="chartData"
                            />
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>

</template>

<script>
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
  name: 'BarChart',
  components: { Bar },
  data() {
    return {
      chartData: {
        labels: [ 'January', 'February', 'March' ],
        datasets: [ { data: [40, 20, 12] } ]
      },
      chartOptions: {
        responsive: true
      }
    }
  }
}
</script>