
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Trace
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Sends application trace data to Stackdriver Trace for viewing. Trace data is collected for all App Engine applications by default. Trace data from other applications can be provided using this API. This library is used to interact with the Trace API directly. If you are looking to instrument your application for Stackdriver Trace, we recommend using OpenCensus.
## 
## 
## https://cloud.google.com/trace
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudtrace"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtraceProjectsTracesList_579677 = ref object of OpenApiRestCall_579408
proc url_CloudtraceProjectsTracesList_579679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesList_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579805 = path.getOrDefault("projectId")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "projectId", valid_579805
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request. Optional.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Type of data returned for traces in the list. Optional. Default is
  ## `MINIMAL`.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endTime: JString
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   orderBy: JString
  ##          : Field used to sort the returned traces. Optional.
  ## Can be one of the following:
  ## 
  ## *   `trace_id`
  ## *   `name` (`name` field of root span in the trace)
  ## *   `duration` (difference between `end_time` and `start_time` fields of
  ##      the root span)
  ## *   `start` (`start_time` field of the root span)
  ## 
  ## Descending order can be specified by appending `desc` to the sort field
  ## (for example, `name desc`).
  ## 
  ## Only one sort field is permitted.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size. Optional.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: JString
  ##         : An optional filter against labels for the request.
  ## 
  ## By default, searches use prefix matching. To specify exact match, prepend
  ## a plus symbol (`+`) to the search term.
  ## Multiple terms are ANDed. Syntax:
  ## 
  ## *   `root:NAME_PREFIX` or `NAME_PREFIX`: Return traces where any root
  ##     span starts with `NAME_PREFIX`.
  ## *   `+root:NAME` or `+NAME`: Return traces where any root span's name is
  ##     exactly `NAME`.
  ## *   `span:NAME_PREFIX`: Return traces where any span starts with
  ##     `NAME_PREFIX`.
  ## *   `+span:NAME`: Return traces where any span's name is exactly
  ##     `NAME`.
  ## *   `latency:DURATION`: Return traces whose overall latency is
  ##     greater or equal to than `DURATION`. Accepted units are nanoseconds
  ##     (`ns`), milliseconds (`ms`), and seconds (`s`). Default is `ms`. For
  ##     example, `latency:24ms` returns traces whose overall latency
  ##     is greater than or equal to 24 milliseconds.
  ## *   `label:LABEL_KEY`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) regardless of the key:value
  ##     pair's value (including empty values).
  ## *   `LABEL_KEY:VALUE_PREFIX`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) whose value starts with
  ##     `VALUE_PREFIX`. Both a key and a value must be specified.
  ## *   `+LABEL_KEY:VALUE`: Return all traces containing a key:value pair
  ##     exactly matching the specified text. Both a key and a value must be
  ##     specified.
  ## *   `method:VALUE`: Equivalent to `/http/method:VALUE`.
  ## *   `url:VALUE`: Equivalent to `/http/url:VALUE`.
  section = newJObject()
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("pageToken")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "pageToken", valid_579808
  var valid_579809 = query.getOrDefault("quotaUser")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "quotaUser", valid_579809
  var valid_579823 = query.getOrDefault("view")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = newJString("VIEW_TYPE_UNSPECIFIED"))
  if valid_579823 != nil:
    section.add "view", valid_579823
  var valid_579824 = query.getOrDefault("alt")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = newJString("json"))
  if valid_579824 != nil:
    section.add "alt", valid_579824
  var valid_579825 = query.getOrDefault("oauth_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "oauth_token", valid_579825
  var valid_579826 = query.getOrDefault("callback")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "callback", valid_579826
  var valid_579827 = query.getOrDefault("access_token")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "access_token", valid_579827
  var valid_579828 = query.getOrDefault("uploadType")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = nil)
  if valid_579828 != nil:
    section.add "uploadType", valid_579828
  var valid_579829 = query.getOrDefault("endTime")
  valid_579829 = validateParameter(valid_579829, JString, required = false,
                                 default = nil)
  if valid_579829 != nil:
    section.add "endTime", valid_579829
  var valid_579830 = query.getOrDefault("orderBy")
  valid_579830 = validateParameter(valid_579830, JString, required = false,
                                 default = nil)
  if valid_579830 != nil:
    section.add "orderBy", valid_579830
  var valid_579831 = query.getOrDefault("key")
  valid_579831 = validateParameter(valid_579831, JString, required = false,
                                 default = nil)
  if valid_579831 != nil:
    section.add "key", valid_579831
  var valid_579832 = query.getOrDefault("$.xgafv")
  valid_579832 = validateParameter(valid_579832, JString, required = false,
                                 default = newJString("1"))
  if valid_579832 != nil:
    section.add "$.xgafv", valid_579832
  var valid_579833 = query.getOrDefault("pageSize")
  valid_579833 = validateParameter(valid_579833, JInt, required = false, default = nil)
  if valid_579833 != nil:
    section.add "pageSize", valid_579833
  var valid_579834 = query.getOrDefault("prettyPrint")
  valid_579834 = validateParameter(valid_579834, JBool, required = false,
                                 default = newJBool(true))
  if valid_579834 != nil:
    section.add "prettyPrint", valid_579834
  var valid_579835 = query.getOrDefault("startTime")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "startTime", valid_579835
  var valid_579836 = query.getOrDefault("filter")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "filter", valid_579836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579859: Call_CloudtraceProjectsTracesList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_579859.validator(path, query, header, formData, body)
  let scheme = call_579859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579859.url(scheme.get, call_579859.host, call_579859.base,
                         call_579859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579859, url, valid)

proc call*(call_579930: Call_CloudtraceProjectsTracesList_579677;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = "";
          view: string = "VIEW_TYPE_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; endTime: string = ""; orderBy: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; startTime: string = ""; filter: string = ""): Recallable =
  ## cloudtraceProjectsTracesList
  ## Returns of a list of traces that match the specified filter conditions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request. Optional.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Type of data returned for traces in the list. Optional. Default is
  ## `MINIMAL`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endTime: string
  ##          : End of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   orderBy: string
  ##          : Field used to sort the returned traces. Optional.
  ## Can be one of the following:
  ## 
  ## *   `trace_id`
  ## *   `name` (`name` field of root span in the trace)
  ## *   `duration` (difference between `end_time` and `start_time` fields of
  ##      the root span)
  ## *   `start` (`start_time` field of the root span)
  ## 
  ## Descending order can be specified by appending `desc` to the sort field
  ## (for example, `name desc`).
  ## 
  ## Only one sort field is permitted.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size. Optional.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: string
  ##         : An optional filter against labels for the request.
  ## 
  ## By default, searches use prefix matching. To specify exact match, prepend
  ## a plus symbol (`+`) to the search term.
  ## Multiple terms are ANDed. Syntax:
  ## 
  ## *   `root:NAME_PREFIX` or `NAME_PREFIX`: Return traces where any root
  ##     span starts with `NAME_PREFIX`.
  ## *   `+root:NAME` or `+NAME`: Return traces where any root span's name is
  ##     exactly `NAME`.
  ## *   `span:NAME_PREFIX`: Return traces where any span starts with
  ##     `NAME_PREFIX`.
  ## *   `+span:NAME`: Return traces where any span's name is exactly
  ##     `NAME`.
  ## *   `latency:DURATION`: Return traces whose overall latency is
  ##     greater or equal to than `DURATION`. Accepted units are nanoseconds
  ##     (`ns`), milliseconds (`ms`), and seconds (`s`). Default is `ms`. For
  ##     example, `latency:24ms` returns traces whose overall latency
  ##     is greater than or equal to 24 milliseconds.
  ## *   `label:LABEL_KEY`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) regardless of the key:value
  ##     pair's value (including empty values).
  ## *   `LABEL_KEY:VALUE_PREFIX`: Return all traces containing the specified
  ##     label key (exact match, case-sensitive) whose value starts with
  ##     `VALUE_PREFIX`. Both a key and a value must be specified.
  ## *   `+LABEL_KEY:VALUE`: Return all traces containing a key:value pair
  ##     exactly matching the specified text. Both a key and a value must be
  ##     specified.
  ## *   `method:VALUE`: Equivalent to `/http/method:VALUE`.
  ## *   `url:VALUE`: Equivalent to `/http/url:VALUE`.
  var path_579931 = newJObject()
  var query_579933 = newJObject()
  add(query_579933, "upload_protocol", newJString(uploadProtocol))
  add(query_579933, "fields", newJString(fields))
  add(query_579933, "pageToken", newJString(pageToken))
  add(query_579933, "quotaUser", newJString(quotaUser))
  add(query_579933, "view", newJString(view))
  add(query_579933, "alt", newJString(alt))
  add(query_579933, "oauth_token", newJString(oauthToken))
  add(query_579933, "callback", newJString(callback))
  add(query_579933, "access_token", newJString(accessToken))
  add(query_579933, "uploadType", newJString(uploadType))
  add(query_579933, "endTime", newJString(endTime))
  add(query_579933, "orderBy", newJString(orderBy))
  add(query_579933, "key", newJString(key))
  add(path_579931, "projectId", newJString(projectId))
  add(query_579933, "$.xgafv", newJString(Xgafv))
  add(query_579933, "pageSize", newJInt(pageSize))
  add(query_579933, "prettyPrint", newJBool(prettyPrint))
  add(query_579933, "startTime", newJString(startTime))
  add(query_579933, "filter", newJString(filter))
  result = call_579930.call(path_579931, query_579933, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_579677(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsTracesList_579678, base: "/",
    url: url_CloudtraceProjectsTracesList_579679, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsPatchTraces_579972 = ref object of OpenApiRestCall_579408
proc url_CloudtraceProjectsPatchTraces_579974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsPatchTraces_579973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_579975 = path.getOrDefault("projectId")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "projectId", valid_579975
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579976 = query.getOrDefault("upload_protocol")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "upload_protocol", valid_579976
  var valid_579977 = query.getOrDefault("fields")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "fields", valid_579977
  var valid_579978 = query.getOrDefault("quotaUser")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "quotaUser", valid_579978
  var valid_579979 = query.getOrDefault("alt")
  valid_579979 = validateParameter(valid_579979, JString, required = false,
                                 default = newJString("json"))
  if valid_579979 != nil:
    section.add "alt", valid_579979
  var valid_579980 = query.getOrDefault("oauth_token")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "oauth_token", valid_579980
  var valid_579981 = query.getOrDefault("callback")
  valid_579981 = validateParameter(valid_579981, JString, required = false,
                                 default = nil)
  if valid_579981 != nil:
    section.add "callback", valid_579981
  var valid_579982 = query.getOrDefault("access_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "access_token", valid_579982
  var valid_579983 = query.getOrDefault("uploadType")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "uploadType", valid_579983
  var valid_579984 = query.getOrDefault("key")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "key", valid_579984
  var valid_579985 = query.getOrDefault("$.xgafv")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("1"))
  if valid_579985 != nil:
    section.add "$.xgafv", valid_579985
  var valid_579986 = query.getOrDefault("prettyPrint")
  valid_579986 = validateParameter(valid_579986, JBool, required = false,
                                 default = newJBool(true))
  if valid_579986 != nil:
    section.add "prettyPrint", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579988: Call_CloudtraceProjectsPatchTraces_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  let valid = call_579988.validator(path, query, header, formData, body)
  let scheme = call_579988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579988.url(scheme.get, call_579988.host, call_579988.base,
                         call_579988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579988, url, valid)

proc call*(call_579989: Call_CloudtraceProjectsPatchTraces_579972;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsPatchTraces
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_579990 = newJObject()
  var query_579991 = newJObject()
  var body_579992 = newJObject()
  add(query_579991, "upload_protocol", newJString(uploadProtocol))
  add(query_579991, "fields", newJString(fields))
  add(query_579991, "quotaUser", newJString(quotaUser))
  add(query_579991, "alt", newJString(alt))
  add(query_579991, "oauth_token", newJString(oauthToken))
  add(query_579991, "callback", newJString(callback))
  add(query_579991, "access_token", newJString(accessToken))
  add(query_579991, "uploadType", newJString(uploadType))
  add(query_579991, "key", newJString(key))
  add(path_579990, "projectId", newJString(projectId))
  add(query_579991, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579992 = body
  add(query_579991, "prettyPrint", newJBool(prettyPrint))
  result = call_579989.call(path_579990, query_579991, nil, nil, body_579992)

var cloudtraceProjectsPatchTraces* = Call_CloudtraceProjectsPatchTraces_579972(
    name: "cloudtraceProjectsPatchTraces", meth: HttpMethod.HttpPatch,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsPatchTraces_579973, base: "/",
    url: url_CloudtraceProjectsPatchTraces_579974, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesGet_579993 = ref object of OpenApiRestCall_579408
proc url_CloudtraceProjectsTracesGet_579995(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "traceId" in path, "`traceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/traces/"),
               (kind: VariableSegment, value: "traceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesGet_579994(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single trace by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   traceId: JString (required)
  ##          : ID of the trace to return.
  ##   projectId: JString (required)
  ##            : ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `traceId` field"
  var valid_579996 = path.getOrDefault("traceId")
  valid_579996 = validateParameter(valid_579996, JString, required = true,
                                 default = nil)
  if valid_579996 != nil:
    section.add "traceId", valid_579996
  var valid_579997 = path.getOrDefault("projectId")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "projectId", valid_579997
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579998 = query.getOrDefault("upload_protocol")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "upload_protocol", valid_579998
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("callback")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "callback", valid_580003
  var valid_580004 = query.getOrDefault("access_token")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "access_token", valid_580004
  var valid_580005 = query.getOrDefault("uploadType")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = nil)
  if valid_580005 != nil:
    section.add "uploadType", valid_580005
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("$.xgafv")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = newJString("1"))
  if valid_580007 != nil:
    section.add "$.xgafv", valid_580007
  var valid_580008 = query.getOrDefault("prettyPrint")
  valid_580008 = validateParameter(valid_580008, JBool, required = false,
                                 default = newJBool(true))
  if valid_580008 != nil:
    section.add "prettyPrint", valid_580008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580009: Call_CloudtraceProjectsTracesGet_579993; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single trace by its ID.
  ## 
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_CloudtraceProjectsTracesGet_579993; traceId: string;
          projectId: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudtraceProjectsTracesGet
  ## Gets a single trace by its ID.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   traceId: string (required)
  ##          : ID of the trace to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  add(query_580012, "upload_protocol", newJString(uploadProtocol))
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(query_580012, "callback", newJString(callback))
  add(query_580012, "access_token", newJString(accessToken))
  add(query_580012, "uploadType", newJString(uploadType))
  add(path_580011, "traceId", newJString(traceId))
  add(query_580012, "key", newJString(key))
  add(path_580011, "projectId", newJString(projectId))
  add(query_580012, "$.xgafv", newJString(Xgafv))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  result = call_580010.call(path_580011, query_580012, nil, nil, nil)

var cloudtraceProjectsTracesGet* = Call_CloudtraceProjectsTracesGet_579993(
    name: "cloudtraceProjectsTracesGet", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com",
    route: "/v1/projects/{projectId}/traces/{traceId}",
    validator: validate_CloudtraceProjectsTracesGet_579994, base: "/",
    url: url_CloudtraceProjectsTracesGet_579995, schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
