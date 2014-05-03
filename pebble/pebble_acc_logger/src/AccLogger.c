#include <pebble.h>

#define SAMPLE_BATCH 15 

static Window *window;
static TextLayer *text_layer;
static TextLayer *acc_layer;

DataLoggingSessionRef acc_log;
static void acc_handler(AccelData*, uint32_t);

static void select_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Select");
}

static void up_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Logging!");
  app_log(APP_LOG_LEVEL_ERROR, "%s%", 3, "log start");
  acc_log = data_logging_create(
				/* tag */           32,
				/* DataLogType */   DATA_LOGGING_BYTE_ARRAY,
				/* length */        sizeof(AccelData), 
				/* resume */        false );


  // register handler for accelerometer data
  accel_service_set_sampling_rate( ACCEL_SAMPLING_25HZ );
  accel_data_service_subscribe(10, acc_handler);
}

static void down_click_handler(ClickRecognizerRef recognizer, void *context) {
  text_layer_set_text(text_layer, "Stopped!");
  data_logging_finish(acc_log);
  accel_data_service_unsubscribe();
}

static void click_config_provider(void *context) {
  window_single_click_subscribe(BUTTON_ID_SELECT, select_click_handler);
  window_single_click_subscribe(BUTTON_ID_UP, up_click_handler);
  window_single_click_subscribe(BUTTON_ID_DOWN, down_click_handler);
}

static void window_load(Window *window) {
  Layer *window_layer = window_get_root_layer(window);
  GRect bounds = layer_get_bounds(window_layer);

  text_layer = text_layer_create((GRect) { .origin = { 0, 62 }, .size = { bounds.size.w, 40 } });
  acc_layer = text_layer_create(GRect(60, 143, 65, 148));

  text_layer_set_text(text_layer, "Press a button");
  text_layer_set_text_alignment(text_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(text_layer));

  text_layer_set_text(text_layer, "Accelerometer data");
  text_layer_set_text_alignment(acc_layer, GTextAlignmentCenter);
  layer_add_child(window_layer, text_layer_get_layer(acc_layer));
}

static void window_unload(Window *window) {
  text_layer_destroy(text_layer);
  text_layer_destroy(acc_layer);
}



static void acc_handler(AccelData *data, uint32_t num_samples) {
  DataLoggingResult r = data_logging_log(acc_log, data, num_samples);

  switch (r) {
  case DATA_LOGGING_FULL:
    text_layer_set_text(text_layer, "logging full");
    break;
  case DATA_LOGGING_BUSY:
    text_layer_set_text(text_layer, "logging busy");
    break;
  case DATA_LOGGING_NOT_FOUND:
    text_layer_set_text(text_layer, "logging not found");
    break;
  case DATA_LOGGING_CLOSED:
    text_layer_set_text(text_layer, "logging closed");
    break;
  case DATA_LOGGING_SUCCESS:
    text_layer_set_text(text_layer, "logging SUCCESSFUL!");
    break;
  default:
    text_layer_set_text(text_layer, "weird!");
    break;
  }
  
  int32_t mx = 0, my = 0, mz = 0;
  for (uint32_t i = 0; i < num_samples; i++) {
    mx += data[i].x;
    my += data[i].y;
    mz += data[i].z;
  }
  mx = mx * 1.0 / num_samples;
  my = my * 1.0 / num_samples;
  mz = mz * 1.0 / num_samples;
  
  char buf[40];
  char buf2[] = "123456";
  snprintf(buf, sizeof(buf), "%d", (int)mx);
  snprintf(buf2, sizeof(buf2), "%d", (int)my);
  strcat(buf, buf2);
  snprintf(buf2, sizeof(buf2), "%d", (int)mz);
  strcat(buf, buf2);
  text_layer_set_text(acc_layer, buf);
}


static void init(void) {
  window = window_create();
  window_set_click_config_provider(window, click_config_provider);
  window_set_window_handlers(window, (WindowHandlers) {
    .load = window_load,
    .unload = window_unload,
  });
  const bool animated = true;

  window_stack_push(window, animated);
}

static void deinit(void) {
  accel_data_service_unsubscribe();
  window_destroy(window);
}

int main(void) {
  init();

  APP_LOG(APP_LOG_LEVEL_DEBUG, "Done initializing, pushed window: %p", window);

  app_event_loop();
  deinit();
}
