
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Stackdriver Trace
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Send and retrieve trace data from Stackdriver Trace. Data is generated and available by default for all App Engine applications. Data from other applications can be written to Stackdriver Trace for display, reporting, and analysis.
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
  gcpServiceName = "tracing"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudtraceProjectsTracesSpansCreate_588710 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesSpansCreate_588712(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesSpansCreate_588711(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Span.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project.
  ## [SPAN_ID] is a unique identifier for a span within a trace,
  ## assigned when the span is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_588838 = path.getOrDefault("name")
  valid_588838 = validateParameter(valid_588838, JString, required = true,
                                 default = nil)
  if valid_588838 != nil:
    section.add "name", valid_588838
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
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
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("pp")
  valid_588856 = validateParameter(valid_588856, JBool, required = false,
                                 default = newJBool(true))
  if valid_588856 != nil:
    section.add "pp", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("callback")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "callback", valid_588858
  var valid_588859 = query.getOrDefault("access_token")
  valid_588859 = validateParameter(valid_588859, JString, required = false,
                                 default = nil)
  if valid_588859 != nil:
    section.add "access_token", valid_588859
  var valid_588860 = query.getOrDefault("uploadType")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "uploadType", valid_588860
  var valid_588861 = query.getOrDefault("key")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "key", valid_588861
  var valid_588862 = query.getOrDefault("$.xgafv")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("1"))
  if valid_588862 != nil:
    section.add "$.xgafv", valid_588862
  var valid_588863 = query.getOrDefault("prettyPrint")
  valid_588863 = validateParameter(valid_588863, JBool, required = false,
                                 default = newJBool(true))
  if valid_588863 != nil:
    section.add "prettyPrint", valid_588863
  var valid_588864 = query.getOrDefault("bearer_token")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "bearer_token", valid_588864
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

proc call*(call_588888: Call_CloudtraceProjectsTracesSpansCreate_588710;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Span.
  ## 
  let valid = call_588888.validator(path, query, header, formData, body)
  let scheme = call_588888.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588888.url(scheme.get, call_588888.host, call_588888.base,
                         call_588888.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588888, url, valid)

proc call*(call_588959: Call_CloudtraceProjectsTracesSpansCreate_588710;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudtraceProjectsTracesSpansCreate
  ## Creates a new Span.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource name of the span in the following format:
  ## 
  ##     projects/[PROJECT_ID]traces/[TRACE_ID]/spans/SPAN_ID is a unique identifier for a trace within a project.
  ## [SPAN_ID] is a unique identifier for a span within a trace,
  ## assigned when the span is created.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_588960 = newJObject()
  var query_588962 = newJObject()
  var body_588963 = newJObject()
  add(query_588962, "upload_protocol", newJString(uploadProtocol))
  add(query_588962, "fields", newJString(fields))
  add(query_588962, "quotaUser", newJString(quotaUser))
  add(path_588960, "name", newJString(name))
  add(query_588962, "alt", newJString(alt))
  add(query_588962, "pp", newJBool(pp))
  add(query_588962, "oauth_token", newJString(oauthToken))
  add(query_588962, "callback", newJString(callback))
  add(query_588962, "access_token", newJString(accessToken))
  add(query_588962, "uploadType", newJString(uploadType))
  add(query_588962, "key", newJString(key))
  add(query_588962, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_588963 = body
  add(query_588962, "prettyPrint", newJBool(prettyPrint))
  add(query_588962, "bearer_token", newJString(bearerToken))
  result = call_588959.call(path_588960, query_588962, nil, nil, body_588963)

var cloudtraceProjectsTracesSpansCreate* = Call_CloudtraceProjectsTracesSpansCreate_588710(
    name: "cloudtraceProjectsTracesSpansCreate", meth: HttpMethod.HttpPut,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}",
    validator: validate_CloudtraceProjectsTracesSpansCreate_588711, base: "/",
    url: url_CloudtraceProjectsTracesSpansCreate_588712, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesBatchWrite_589002 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesBatchWrite_589004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/traces:batchWrite")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesBatchWrite_589003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Name of the project where the spans belong. The format is
  ## `projects/PROJECT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_589005 = path.getOrDefault("name")
  valid_589005 = validateParameter(valid_589005, JString, required = true,
                                 default = nil)
  if valid_589005 != nil:
    section.add "name", valid_589005
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
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589006 = query.getOrDefault("upload_protocol")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = nil)
  if valid_589006 != nil:
    section.add "upload_protocol", valid_589006
  var valid_589007 = query.getOrDefault("fields")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "fields", valid_589007
  var valid_589008 = query.getOrDefault("quotaUser")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "quotaUser", valid_589008
  var valid_589009 = query.getOrDefault("alt")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("json"))
  if valid_589009 != nil:
    section.add "alt", valid_589009
  var valid_589010 = query.getOrDefault("pp")
  valid_589010 = validateParameter(valid_589010, JBool, required = false,
                                 default = newJBool(true))
  if valid_589010 != nil:
    section.add "pp", valid_589010
  var valid_589011 = query.getOrDefault("oauth_token")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "oauth_token", valid_589011
  var valid_589012 = query.getOrDefault("callback")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = nil)
  if valid_589012 != nil:
    section.add "callback", valid_589012
  var valid_589013 = query.getOrDefault("access_token")
  valid_589013 = validateParameter(valid_589013, JString, required = false,
                                 default = nil)
  if valid_589013 != nil:
    section.add "access_token", valid_589013
  var valid_589014 = query.getOrDefault("uploadType")
  valid_589014 = validateParameter(valid_589014, JString, required = false,
                                 default = nil)
  if valid_589014 != nil:
    section.add "uploadType", valid_589014
  var valid_589015 = query.getOrDefault("key")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "key", valid_589015
  var valid_589016 = query.getOrDefault("$.xgafv")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = newJString("1"))
  if valid_589016 != nil:
    section.add "$.xgafv", valid_589016
  var valid_589017 = query.getOrDefault("prettyPrint")
  valid_589017 = validateParameter(valid_589017, JBool, required = false,
                                 default = newJBool(true))
  if valid_589017 != nil:
    section.add "prettyPrint", valid_589017
  var valid_589018 = query.getOrDefault("bearer_token")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = nil)
  if valid_589018 != nil:
    section.add "bearer_token", valid_589018
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

proc call*(call_589020: Call_CloudtraceProjectsTracesBatchWrite_589002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ## 
  let valid = call_589020.validator(path, query, header, formData, body)
  let scheme = call_589020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589020.url(scheme.get, call_589020.host, call_589020.base,
                         call_589020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589020, url, valid)

proc call*(call_589021: Call_CloudtraceProjectsTracesBatchWrite_589002;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          body: JsonNode = nil; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudtraceProjectsTracesBatchWrite
  ## Sends new spans to Stackdriver Trace or updates existing traces. If the
  ## name of a trace that you send matches that of an existing trace, new spans
  ## are added to the existing trace. Attempt to update existing spans results
  ## undefined behavior. If the name does not match, a new trace is created
  ## with given set of spans.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Name of the project where the spans belong. The format is
  ## `projects/PROJECT_ID`.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589022 = newJObject()
  var query_589023 = newJObject()
  var body_589024 = newJObject()
  add(query_589023, "upload_protocol", newJString(uploadProtocol))
  add(query_589023, "fields", newJString(fields))
  add(query_589023, "quotaUser", newJString(quotaUser))
  add(path_589022, "name", newJString(name))
  add(query_589023, "alt", newJString(alt))
  add(query_589023, "pp", newJBool(pp))
  add(query_589023, "oauth_token", newJString(oauthToken))
  add(query_589023, "callback", newJString(callback))
  add(query_589023, "access_token", newJString(accessToken))
  add(query_589023, "uploadType", newJString(uploadType))
  add(query_589023, "key", newJString(key))
  add(query_589023, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589024 = body
  add(query_589023, "prettyPrint", newJBool(prettyPrint))
  add(query_589023, "bearer_token", newJString(bearerToken))
  result = call_589021.call(path_589022, query_589023, nil, nil, body_589024)

var cloudtraceProjectsTracesBatchWrite* = Call_CloudtraceProjectsTracesBatchWrite_589002(
    name: "cloudtraceProjectsTracesBatchWrite", meth: HttpMethod.HttpPost,
    host: "cloudtrace.googleapis.com", route: "/v2/{name}/traces:batchWrite",
    validator: validate_CloudtraceProjectsTracesBatchWrite_589003, base: "/",
    url: url_CloudtraceProjectsTracesBatchWrite_589004, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesList_589025 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesList_589027(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/traces")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesList_589026(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The project where the trace data is stored. The format
  ## is `projects/PROJECT_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589028 = path.getOrDefault("parent")
  valid_589028 = validateParameter(valid_589028, JString, required = true,
                                 default = nil)
  if valid_589028 != nil:
    section.add "parent", valid_589028
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method.  `page_token` must be the value of
  ## `next_page_token` from the previous response.  The values of other method
  ## parameters should be identical to those in the previous call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   endTime: JString
  ##          : Optional. Do not return traces whose start time is later than this time.
  ##   orderBy: JString
  ##          : Optional. A single field used to sort the returned traces.
  ## Only the following field names can be used:
  ## 
  ## *   `trace_id`: the trace's ID field
  ## *   `name`:  the root span's resource name
  ## *   `duration`: the difference between the root span's start time and end time
  ## *   `start`:  the start time of the root span
  ## 
  ## Sorting is in ascending order unless `desc` is appended to the sort field name.
  ## Example: `"name desc"`).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Optional. The maximum number of results to return from this request.
  ## Non-positive values are ignored. The presence of `next_page_token` in the
  ## response indicates that more results might be available, even if fewer than
  ## the maximum number of results is returned by this request.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: JString
  ##            : Optional. Do not return traces whose end time is earlier than this time.
  ##   filter: JString
  ##         : Opional. Return only traces that match this
  ## [trace filter](/trace/docs/trace-filters). Example:
  ## 
  ##     "label:/http/url root:/_ah/background my_label:17"
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589029 = query.getOrDefault("upload_protocol")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "upload_protocol", valid_589029
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("pageToken")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "pageToken", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("pp")
  valid_589034 = validateParameter(valid_589034, JBool, required = false,
                                 default = newJBool(true))
  if valid_589034 != nil:
    section.add "pp", valid_589034
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
  var valid_589039 = query.getOrDefault("endTime")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "endTime", valid_589039
  var valid_589040 = query.getOrDefault("orderBy")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "orderBy", valid_589040
  var valid_589041 = query.getOrDefault("key")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "key", valid_589041
  var valid_589042 = query.getOrDefault("$.xgafv")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("1"))
  if valid_589042 != nil:
    section.add "$.xgafv", valid_589042
  var valid_589043 = query.getOrDefault("pageSize")
  valid_589043 = validateParameter(valid_589043, JInt, required = false, default = nil)
  if valid_589043 != nil:
    section.add "pageSize", valid_589043
  var valid_589044 = query.getOrDefault("prettyPrint")
  valid_589044 = validateParameter(valid_589044, JBool, required = false,
                                 default = newJBool(true))
  if valid_589044 != nil:
    section.add "prettyPrint", valid_589044
  var valid_589045 = query.getOrDefault("startTime")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "startTime", valid_589045
  var valid_589046 = query.getOrDefault("filter")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "filter", valid_589046
  var valid_589047 = query.getOrDefault("bearer_token")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "bearer_token", valid_589047
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589048: Call_CloudtraceProjectsTracesList_589025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns of a list of traces that match the specified filter conditions.
  ## 
  let valid = call_589048.validator(path, query, header, formData, body)
  let scheme = call_589048.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589048.url(scheme.get, call_589048.host, call_589048.base,
                         call_589048.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589048, url, valid)

proc call*(call_589049: Call_CloudtraceProjectsTracesList_589025; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; pp: bool = true;
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; endTime: string = ""; orderBy: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; startTime: string = ""; filter: string = "";
          bearerToken: string = ""): Recallable =
  ## cloudtraceProjectsTracesList
  ## Returns of a list of traces that match the specified filter conditions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method.  `page_token` must be the value of
  ## `next_page_token` from the previous response.  The values of other method
  ## parameters should be identical to those in the previous call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The project where the trace data is stored. The format
  ## is `projects/PROJECT_ID`.
  ##   endTime: string
  ##          : Optional. Do not return traces whose start time is later than this time.
  ##   orderBy: string
  ##          : Optional. A single field used to sort the returned traces.
  ## Only the following field names can be used:
  ## 
  ## *   `trace_id`: the trace's ID field
  ## *   `name`:  the root span's resource name
  ## *   `duration`: the difference between the root span's start time and end time
  ## *   `start`:  the start time of the root span
  ## 
  ## Sorting is in ascending order unless `desc` is appended to the sort field name.
  ## Example: `"name desc"`).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Optional. The maximum number of results to return from this request.
  ## Non-positive values are ignored. The presence of `next_page_token` in the
  ## response indicates that more results might be available, even if fewer than
  ## the maximum number of results is returned by this request.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startTime: string
  ##            : Optional. Do not return traces whose end time is earlier than this time.
  ##   filter: string
  ##         : Opional. Return only traces that match this
  ## [trace filter](/trace/docs/trace-filters). Example:
  ## 
  ##     "label:/http/url root:/_ah/background my_label:17"
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589050 = newJObject()
  var query_589051 = newJObject()
  add(query_589051, "upload_protocol", newJString(uploadProtocol))
  add(query_589051, "fields", newJString(fields))
  add(query_589051, "pageToken", newJString(pageToken))
  add(query_589051, "quotaUser", newJString(quotaUser))
  add(query_589051, "alt", newJString(alt))
  add(query_589051, "pp", newJBool(pp))
  add(query_589051, "oauth_token", newJString(oauthToken))
  add(query_589051, "callback", newJString(callback))
  add(query_589051, "access_token", newJString(accessToken))
  add(query_589051, "uploadType", newJString(uploadType))
  add(path_589050, "parent", newJString(parent))
  add(query_589051, "endTime", newJString(endTime))
  add(query_589051, "orderBy", newJString(orderBy))
  add(query_589051, "key", newJString(key))
  add(query_589051, "$.xgafv", newJString(Xgafv))
  add(query_589051, "pageSize", newJInt(pageSize))
  add(query_589051, "prettyPrint", newJBool(prettyPrint))
  add(query_589051, "startTime", newJString(startTime))
  add(query_589051, "filter", newJString(filter))
  add(query_589051, "bearer_token", newJString(bearerToken))
  result = call_589049.call(path_589050, query_589051, nil, nil, nil)

var cloudtraceProjectsTracesList* = Call_CloudtraceProjectsTracesList_589025(
    name: "cloudtraceProjectsTracesList", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v2/{parent}/traces",
    validator: validate_CloudtraceProjectsTracesList_589026, base: "/",
    url: url_CloudtraceProjectsTracesList_589027, schemes: {Scheme.Https})
type
  Call_CloudtraceProjectsTracesListSpans_589052 = ref object of OpenApiRestCall_588441
proc url_CloudtraceProjectsTracesListSpans_589054(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":listSpans")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudtraceProjectsTracesListSpans_589053(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns a list of spans within a trace.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required: The resource name of the trace containing the spans to list.
  ## The format is `projects/PROJECT_ID/traces/TRACE_ID`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_589055 = path.getOrDefault("parent")
  valid_589055 = validateParameter(valid_589055, JString, required = true,
                                 default = nil)
  if valid_589055 != nil:
    section.add "parent", valid_589055
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method. `page_token` must be the value of
  ## `next_page_token` from the previous response. The values of other method
  ## parameters should be identical to those in the previous call.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   pp: JBool
  ##     : Pretty-print response.
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
  ##   bearer_token: JString
  ##               : OAuth bearer token.
  section = newJObject()
  var valid_589056 = query.getOrDefault("upload_protocol")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "upload_protocol", valid_589056
  var valid_589057 = query.getOrDefault("fields")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = nil)
  if valid_589057 != nil:
    section.add "fields", valid_589057
  var valid_589058 = query.getOrDefault("pageToken")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "pageToken", valid_589058
  var valid_589059 = query.getOrDefault("quotaUser")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "quotaUser", valid_589059
  var valid_589060 = query.getOrDefault("alt")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = newJString("json"))
  if valid_589060 != nil:
    section.add "alt", valid_589060
  var valid_589061 = query.getOrDefault("pp")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "pp", valid_589061
  var valid_589062 = query.getOrDefault("oauth_token")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "oauth_token", valid_589062
  var valid_589063 = query.getOrDefault("callback")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "callback", valid_589063
  var valid_589064 = query.getOrDefault("access_token")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "access_token", valid_589064
  var valid_589065 = query.getOrDefault("uploadType")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "uploadType", valid_589065
  var valid_589066 = query.getOrDefault("key")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "key", valid_589066
  var valid_589067 = query.getOrDefault("$.xgafv")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("1"))
  if valid_589067 != nil:
    section.add "$.xgafv", valid_589067
  var valid_589068 = query.getOrDefault("prettyPrint")
  valid_589068 = validateParameter(valid_589068, JBool, required = false,
                                 default = newJBool(true))
  if valid_589068 != nil:
    section.add "prettyPrint", valid_589068
  var valid_589069 = query.getOrDefault("bearer_token")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "bearer_token", valid_589069
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589070: Call_CloudtraceProjectsTracesListSpans_589052;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns a list of spans within a trace.
  ## 
  let valid = call_589070.validator(path, query, header, formData, body)
  let scheme = call_589070.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589070.url(scheme.get, call_589070.host, call_589070.base,
                         call_589070.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589070, url, valid)

proc call*(call_589071: Call_CloudtraceProjectsTracesListSpans_589052;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          pp: bool = true; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true; bearerToken: string = ""): Recallable =
  ## cloudtraceProjectsTracesListSpans
  ## Returns a list of spans within a trace.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Optional. If present, then retrieve the next batch of results from the
  ## preceding call to this method. `page_token` must be the value of
  ## `next_page_token` from the previous response. The values of other method
  ## parameters should be identical to those in the previous call.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   pp: bool
  ##     : Pretty-print response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required: The resource name of the trace containing the spans to list.
  ## The format is `projects/PROJECT_ID/traces/TRACE_ID`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   bearerToken: string
  ##              : OAuth bearer token.
  var path_589072 = newJObject()
  var query_589073 = newJObject()
  add(query_589073, "upload_protocol", newJString(uploadProtocol))
  add(query_589073, "fields", newJString(fields))
  add(query_589073, "pageToken", newJString(pageToken))
  add(query_589073, "quotaUser", newJString(quotaUser))
  add(query_589073, "alt", newJString(alt))
  add(query_589073, "pp", newJBool(pp))
  add(query_589073, "oauth_token", newJString(oauthToken))
  add(query_589073, "callback", newJString(callback))
  add(query_589073, "access_token", newJString(accessToken))
  add(query_589073, "uploadType", newJString(uploadType))
  add(path_589072, "parent", newJString(parent))
  add(query_589073, "key", newJString(key))
  add(query_589073, "$.xgafv", newJString(Xgafv))
  add(query_589073, "prettyPrint", newJBool(prettyPrint))
  add(query_589073, "bearer_token", newJString(bearerToken))
  result = call_589071.call(path_589072, query_589073, nil, nil, nil)

var cloudtraceProjectsTracesListSpans* = Call_CloudtraceProjectsTracesListSpans_589052(
    name: "cloudtraceProjectsTracesListSpans", meth: HttpMethod.HttpGet,
    host: "cloudtrace.googleapis.com", route: "/v2/{parent}:listSpans",
    validator: validate_CloudtraceProjectsTracesListSpans_589053, base: "/",
    url: url_CloudtraceProjectsTracesListSpans_589054, schemes: {Scheme.Https})
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
