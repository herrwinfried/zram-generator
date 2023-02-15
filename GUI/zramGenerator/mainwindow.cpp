#include "mainwindow.h"
#include "./ui_mainwindow.h"
#include <QMessageBox>
#include <QProcess>

using namespace std;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
    this->setFixedSize(this->width(),this->height());

    QMessageBox msgBox;
    QPushButton *connectButton = msgBox.addButton(tr("Okey"), msgBox.ActionRole);
    msgBox.setWindowTitle(tr("Before You Begin"));
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(tr("This interface is experimental. No liability is accepted."));
    msgBox.exec();
}

MainWindow::~MainWindow()
{
    delete ui;

}


void MainWindow::on_horizontalSlider_valueChanged(int value)
{
    ui->spinBox->setValue(ui->horizontalSlider->value());
}


void MainWindow::on_spinBox_valueChanged(int arg1)
{
     ui->horizontalSlider->setValue(ui->spinBox->value());
}


void MainWindow::on_type_currentIndexChanged(int index)
{
    if (index == 0) {
        //KiB
        ui->horizontalSlider->setMaximum(209715200);
        ui->horizontalSlider->setMinimum(512000);
        ui->spinBox->setMaximum(209715200);
        ui->spinBox->setMinimum(512000);
        ui->spinBox->setValue(ui->spinBox->minimum());
        ui->horizontalSlider->setValue(ui->horizontalSlider->minimum());
    } else if (index == 1) {
        //MiB
        ui->horizontalSlider->setMaximum(204800);
        ui->horizontalSlider->setMinimum(500);
        ui->spinBox->setMaximum(204800);
        ui->spinBox->setMinimum(500);
        ui->spinBox->setValue(ui->spinBox->minimum());
        ui->horizontalSlider->setValue(ui->horizontalSlider->minimum());
    } else if (index == 2) {
        //GiB
        ui->horizontalSlider->setMaximum(200);
        ui->horizontalSlider->setMinimum(1);
        ui->spinBox->setMaximum(200);
        ui->spinBox->setMinimum(1);
        ui->spinBox->setValue(ui->spinBox->minimum());
        ui->horizontalSlider->setValue(ui->horizontalSlider->minimum());
    }
}


void MainWindow::on_exit_clicked()
{
 this->close();
}

void MainWindow::on_ready_clicked()
{
QString Result = ui->spinBox->text() + " " + ui->type->currentText();
    QMessageBox msgBox;
    msgBox.addButton(tr("I understand, I accept"), msgBox.ActionRole);
    msgBox.addButton(tr("Cancel"), msgBox.ActionRole);
    msgBox.setWindowTitle(tr("Before You Begin"));
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(tr("If there is existing Zram, you need to uninstall it. This method is experimental, it can delete the existing Zram in your hand or make it unusable if you do not delete the existing zram in your hand. \n\nWhen you want to stop it, just type the '%1' command into the terminal. \n\nUse it consciously. No Liability is accepted.").arg("sudo systemctl disable zram-manuel-script"));
    int ret = msgBox.exec();

if (ret == 0) {
    QMessageBox msgBox;
    msgBox.addButton("GitHub", msgBox.ActionRole);
    msgBox.addButton("GitLab", msgBox.ActionRole);
    msgBox.addButton(tr("Cancel"), msgBox.ActionRole);
    msgBox.setWindowTitle(tr("Where would you like to Download?"));
    msgBox.setIcon(QMessageBox::Warning);
    msgBox.setText(tr("Where do you want to download? Please choose."));
    int Re_ret = msgBox.exec();
    QString URL;
    if (Re_ret == 0) {
        //Github
         QString URL = "";
    } else if (Re_ret == 1) {
        //Gitlab
         QString URL = "";
    }
    if (Re_ret != 2) {
    QProcess::startDetached("/bin/bash", QStringList() << "-c" << QString("pkexec bash -c \" cd /tmp/ ; wget " + URL + " -o zram-script.sh; chmod +x ./zram-script.sh ; sh ./zram-script.sh" + Result + "  \" "));
    ui->statusbar->showMessage(tr("Process Started, Please type '%1' in terminal after 4 minutes and check").arg("systemctl status zram-manuel-script"), 1000000);
} else {
            ui->statusbar->showMessage(tr("Process canceled"), 50000);
    }
    }
if (ret == 1) {
    ui->statusbar->showMessage(tr("Process canceled"), 50000);
}
}

