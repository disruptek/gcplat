
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
  Call_CloudtraceProjectsTracesList_588710 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesList_588712(protocol: Scheme; host: string;
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

proc validate_CloudtraceProjectsTracesList_588711(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_588838 = path.getOrDefault("projectId")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "projectId", valid_588838
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token identifying the page of results to return. If provided, use the
  ## value of the `next_page_token` field from a previous request.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: JString
  ##       : Optional. Type of data returned for traces in the list. Default is
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
  ##          : Optional. Field used to sort the returned traces.
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
  ##           : Optional. Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: JString
  ##         : Optional. A filter against labels for the request.
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
  var valid_588839 = query.getOrDefault("upload_protocol")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "upload_protocol", valid_588839
  var valid_588840 = query.getOrDefault("fields")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "fields", valid_588840
  var valid_588841 = query.getOrDefault("pageToken")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "pageToken", valid_588841
  var valid_588842 = query.getOrDefault("quotaUser")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "quotaUser", valid_588842
  var valid_588856 = query.getOrDefault("view")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = newJString("VIEW_TYPE_UNSPECIFIED"))
  if valid_588856 != nil:
    section.add "view", valid_588856
  var valid_588857 = query.getOrDefault("alt")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = newJString("json"))
  if valid_588857 != nil:
    section.add "alt", valid_588857
  var valid_588858 = query.getOrDefault("oauth_token")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "oauth_token", valid_588858
  var valid_588859 = query.getOrDefault("callback")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "callback", valid_588859
  var valid_588860 = query.getOrDefault("access_token")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "access_token", valid_588860
  var valid_588861 = query.getOrDefault("uploadType")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "uploadType", valid_588861
  var valid_588862 = query.getOrDefault("endTime")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = nil)
  if valid_588862 != nil:
    section.add "endTime", valid_588862
  var valid_588863 = query.getOrDefault("orderBy")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = nil)
  if valid_588863 != nil:
    section.add "orderBy", valid_588863
  var valid_588864 = query.getOrDefault("key")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "key", valid_588864
  var valid_588865 = query.getOrDefault("$.xgafv")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = newJString("1"))
  if valid_588865 != nil:
    section.add "$.xgafv", valid_588865
  var valid_588866 = query.getOrDefault("pageSize")
  valid_588866 = validateParameter(valid_588866, JInt, required = false, default = nil)
  if valid_588866 != nil:
    section.add "pageSize", valid_588866
  var valid_588867 = query.getOrDefault("prettyPrint")
  valid_588867 = validateParameter(valid_588867, JBool, required = false,
                                 default = newJBool(true))
  if valid_588867 != nil:
    section.add "prettyPrint", valid_588867
  var valid_588868 = query.getOrDefault("startTime")
  valid_588868 = validateParameter(valid_588868, JString, required = false,
                                 default = nil)
  if valid_588868 != nil:
    section.add "startTime", valid_588868
  var valid_588869 = query.getOrDefault("filter")
  valid_588869 = validateParameter(valid_588869, JString, required = false,
                                 default = nil)
  if valid_588869 != nil:
    section.add "filter", valid_588869
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588892: Call_CloudtraceProjectsTracesList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_588892.validator(path, query, header, formData, body)
  let scheme = call_588892.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588892.url(scheme.get, call_588892.host, call_588892.base,
                         call_588892.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588892, url, valid)

proc call*(call_588963: Call_CloudtraceProjectsTracesList_588710;
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
  ## value of the `next_page_token` field from a previous request.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   view: string
  ##       : Optional. Type of data returned for traces in the list. Default is
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
  ##          : Optional. Field used to sort the returned traces.
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
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. Maximum number of traces to return. If not specified or <= 0, the
  ## implementation selects a reasonable value.  The implementation may
  ## return fewer traces than the requested page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Start of the time interval (inclusive) during which the trace data was
  ## collected from the application.
  ##   filter: string
  ##         : Optional. A filter against labels for the request.
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
  var path_588964 = newJObject()
  var query_588966 = newJObject()
  add(query_588966, "upload_protocol", newJString(uploadProtocol))
  add(query_588966, "fields", newJString(fields))
  add(query_588966, "pageToken", newJString(pageToken))
  add(query_588966, "quotaUser", newJString(quotaUser))
  add(query_588966, "view", newJString(view))
  add(query_588966, "alt", newJString(alt))
  add(query_588966, "oauth_token", newJString(oauthToken))
  add(query_588966, "callback", newJString(callback))
  add(query_588966, "access_token", newJString(accessToken))
  add(query_588966, "uploadType", newJString(uploadType))
  add(query_588966, "endTime", newJString(endTime))
  add(query_588966, "orderBy", newJString(orderBy))
  add(query_588966, "key", newJString(key))
  add(path_588964, "projectId", newJString(projectId))
  add(query_588966, "$.xgafv", newJString(Xgafv))
  add(query_588966, "pageSize", newJInt(pageSize))
  add(query_588966, "prettyPrint", newJBool(prettyPrint))
  add(query_588966, "startTime", newJString(startTime))
  add(query_588966, "filter", newJString(filter))
  result = call_588963.call(path_588964, query_588966, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_588710(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsTracesList_588711, base: "/",
    url: url_CloudtraceProjectsTracesList_588712, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsPatchTraces_589005 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsPatchTraces_589007(protocol: Scheme; host: string;
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

proc validate_CloudtraceProjectsPatchTraces_589006(path: JsonNode; query: JsonNode;
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
  ##            : Required. ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_589008 = path.getOrDefault("projectId")
  valid_589008 = validateParameter(valid_589008, JString, required = true,
                                 default = nil)
  if valid_589008 != nil:
    section.add "projectId", valid_589008
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
  var valid_589009 = query.getOrDefault("upload_protocol")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = nil)
  if valid_589009 != nil:
    section.add "upload_protocol", valid_589009
  var valid_589010 = query.getOrDefault("fields")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "fields", valid_589010
  var valid_589011 = query.getOrDefault("quotaUser")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "quotaUser", valid_589011
  var valid_589012 = query.getOrDefault("alt")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("json"))
  if valid_589012 != nil:
    section.add "alt", valid_589012
  var valid_589013 = query.getOrDefault("oauth_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "oauth_token", valid_589013
  var valid_589014 = query.getOrDefault("callback")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "callback", valid_589014
  var valid_589015 = query.getOrDefault("access_token")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "access_token", valid_589015
  var valid_589016 = query.getOrDefault("uploadType")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "uploadType", valid_589016
  var valid_589017 = query.getOrDefault("key")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "key", valid_589017
  var valid_589018 = query.getOrDefault("$.xgafv")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("1"))
  if valid_589018 != nil:
    section.add "$.xgafv", valid_589018
  var valid_589019 = query.getOrDefault("prettyPrint")
  valid_589019 = validateParameter(valid_589019, JBool, required = false,
                                 default = newJBool(true))
  if valid_589019 != nil:
    section.add "prettyPrint", valid_589019
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

proc call*(call_589021: Call_CloudtraceProjectsPatchTraces_589005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Sends new traces to Stackdriver Trace or updates existing traces. If the ID
  ## of a trace that you send matches that of an existing trace, any fields
  ## in the existing trace and its spans are overwritten by the provided values,
  ## and any new fields provided are merged with the existing trace data. If the
  ## ID does not match, a new trace is created.
  ## 
  let valid = call_589021.validator(path, query, header, formData, body)
  let scheme = call_589021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589021.url(scheme.get, call_589021.host, call_589021.base,
                         call_589021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589021, url, valid)

proc call*(call_589022: Call_CloudtraceProjectsPatchTraces_589005;
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
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589023 = newJObject()
  var query_589024 = newJObject()
  var body_589025 = newJObject()
  add(query_589024, "upload_protocol", newJString(uploadProtocol))
  add(query_589024, "fields", newJString(fields))
  add(query_589024, "quotaUser", newJString(quotaUser))
  add(query_589024, "alt", newJString(alt))
  add(query_589024, "oauth_token", newJString(oauthToken))
  add(query_589024, "callback", newJString(callback))
  add(query_589024, "access_token", newJString(accessToken))
  add(query_589024, "uploadType", newJString(uploadType))
  add(query_589024, "key", newJString(key))
  add(path_589023, "projectId", newJString(projectId))
  add(query_589024, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589025 = body
  add(query_589024, "prettyPrint", newJBool(prettyPrint))
  result = call_589022.call(path_589023, query_589024, nil, nil, body_589025)

var cloudtraceProjectsPatchTraces* = Call_CloudtraceProjectsPatchTraces_589005(
    name: "cloudtraceProjectsPatchTraces", meth: HttpMethod.HttpPatch,
    host: "cloudtrace.googleapis.com", route: "/v1/projects/{projectId}/traces",
    validator: validate_CloudtraceProjectsPatchTraces_589006, base: "/",
    url: url_CloudtraceProjectsPatchTraces_589007, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesGet_589026 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesGet_589028(protocol: Scheme; host: string;
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

proc validate_CloudtraceProjectsTracesGet_589027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a single trace by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   traceId: JString (required)
  ##          : Required. ID of the trace to return.
  ##   projectId: JString (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `traceId` field"
  var valid_589029 = path.getOrDefault("traceId")
  valid_589029 = validateParameter(valid_589029, JString, required = true,
                                 default = nil)
  if valid_589029 != nil:
    section.add "traceId", valid_589029
  var valid_589030 = path.getOrDefault("projectId")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "projectId", valid_589030
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
  var valid_589031 = query.getOrDefault("upload_protocol")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "upload_protocol", valid_589031
  var valid_589032 = query.getOrDefault("fields")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "fields", valid_589032
  var valid_589033 = query.getOrDefault("quotaUser")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "quotaUser", valid_589033
  var valid_589034 = query.getOrDefault("alt")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("json"))
  if valid_589034 != nil:
    section.add "alt", valid_589034
  var valid_589035 = query.getOrDefault("oauth_token")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "oauth_token", valid_589035
  var valid_589036 = query.getOrDefault("callback")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "callback", valid_589036
  var valid_589037 = query.getOrDefault("access_token")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = nil)
  if valid_589037 != nil:
    section.add "access_token", valid_589037
  var valid_589038 = query.getOrDefault("uploadType")
  valid_589038 = validateParameter(valid_589038, JString, required = false,
                                 default = nil)
  if valid_589038 != nil:
    section.add "uploadType", valid_589038
  var valid_589039 = query.getOrDefault("key")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "key", valid_589039
  var valid_589040 = query.getOrDefault("$.xgafv")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = newJString("1"))
  if valid_589040 != nil:
    section.add "$.xgafv", valid_589040
  var valid_589041 = query.getOrDefault("prettyPrint")
  valid_589041 = validateParameter(valid_589041, JBool, required = false,
                                 default = newJBool(true))
  if valid_589041 != nil:
    section.add "prettyPrint", valid_589041
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589042: Call_CloudtraceProjectsTracesGet_589026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a single trace by its ID.
  ## 
  let valid = call_589042.validator(path, query, header, formData, body)
  let scheme = call_589042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589042.url(scheme.get, call_589042.host, call_589042.base,
                         call_589042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589042, url, valid)

proc call*(call_589043: Call_CloudtraceProjectsTracesGet_589026; traceId: string;
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
  ##          : Required. ID of the trace to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Required. ID of the Cloud project where the trace data is stored.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589044 = newJObject()
  var query_589045 = newJObject()
  add(query_589045, "upload_protocol", newJString(uploadProtocol))
  add(query_589045, "fields", newJString(fields))
  add(query_589045, "quotaUser", newJString(quotaUser))
  add(query_589045, "alt", newJString(alt))
  add(query_589045, "oauth_token", newJString(oauthToken))
  add(query_589045, "callback", newJString(callback))
  add(query_589045, "access_token", newJString(accessToken))
  add(query_589045, "uploadType", newJString(uploadType))
  add(path_589044, "traceId", newJString(traceId))
  add(query_589045, "key", newJString(key))
  add(path_589044, "projectId", newJString(projectId))
  add(query_589045, "$.xgafv", newJString(Xgafv))
  add(query_589045, "prettyPrint", newJBool(prettyPrint))
  result = call_589043.call(path_589044, query_589045, nil, nil, nil)

var cloudtraceProjectsTracesGet* = Call_CloudtraceProjectsTracesGet_589026(
    name: "cloudtraceProjectsTracesGet", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com",
    route: "/v1/projects/{projectId}/traces/{traceId}",
    validator: validate_CloudtraceProjectsTracesGet_589027, base: "/",
    url: url_CloudtraceProjectsTracesGet_589028, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
