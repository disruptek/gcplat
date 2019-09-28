
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Genomics
## version: v1alpha2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Uploads, processes, queries, and searches Genomics data in the cloud.
## 
## https://cloud.google.com/genomics
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
  gcpServiceName = "genomics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GenomicsPipelinesCreate_579953 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesCreate_579955(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesCreate_579954(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_579956 = query.getOrDefault("upload_protocol")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "upload_protocol", valid_579956
  var valid_579957 = query.getOrDefault("fields")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "fields", valid_579957
  var valid_579958 = query.getOrDefault("quotaUser")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "quotaUser", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("oauth_token")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "oauth_token", valid_579960
  var valid_579961 = query.getOrDefault("callback")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "callback", valid_579961
  var valid_579962 = query.getOrDefault("access_token")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "access_token", valid_579962
  var valid_579963 = query.getOrDefault("uploadType")
  valid_579963 = validateParameter(valid_579963, JString, required = false,
                                 default = nil)
  if valid_579963 != nil:
    section.add "uploadType", valid_579963
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("$.xgafv")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = newJString("1"))
  if valid_579965 != nil:
    section.add "$.xgafv", valid_579965
  var valid_579966 = query.getOrDefault("prettyPrint")
  valid_579966 = validateParameter(valid_579966, JBool, required = false,
                                 default = newJBool(true))
  if valid_579966 != nil:
    section.add "prettyPrint", valid_579966
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

proc call*(call_579968: Call_GenomicsPipelinesCreate_579953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_579968.validator(path, query, header, formData, body)
  let scheme = call_579968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579968.url(scheme.get, call_579968.host, call_579968.base,
                         call_579968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579968, url, valid)

proc call*(call_579969: Call_GenomicsPipelinesCreate_579953;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesCreate
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579970 = newJObject()
  var body_579971 = newJObject()
  add(query_579970, "upload_protocol", newJString(uploadProtocol))
  add(query_579970, "fields", newJString(fields))
  add(query_579970, "quotaUser", newJString(quotaUser))
  add(query_579970, "alt", newJString(alt))
  add(query_579970, "oauth_token", newJString(oauthToken))
  add(query_579970, "callback", newJString(callback))
  add(query_579970, "access_token", newJString(accessToken))
  add(query_579970, "uploadType", newJString(uploadType))
  add(query_579970, "key", newJString(key))
  add(query_579970, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_579971 = body
  add(query_579970, "prettyPrint", newJBool(prettyPrint))
  result = call_579969.call(nil, query_579970, nil, nil, body_579971)

var genomicsPipelinesCreate* = Call_GenomicsPipelinesCreate_579953(
    name: "genomicsPipelinesCreate", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesCreate_579954, base: "/",
    url: url_GenomicsPipelinesCreate_579955, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesList_579677 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesList_579679(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesList_579678(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to use to indicate where to start getting results.
  ## If unspecified, returns the first page of results.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   namePrefix: JString
  ##             : Pipelines with names that match this prefix should be
  ## returned.  If unspecified, all pipelines in the project, up to
  ## `pageSize`, will be returned.
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
  ##   pageSize: JInt
  ##           : Number of pipelines to return at once. Defaults to 256, and max
  ## is 2048.
  ##   projectId: JString
  ##            : Required. The name of the project to search for pipelines. Caller
  ## must have READ access to this project.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_579791 = query.getOrDefault("upload_protocol")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "upload_protocol", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  var valid_579793 = query.getOrDefault("pageToken")
  valid_579793 = validateParameter(valid_579793, JString, required = false,
                                 default = nil)
  if valid_579793 != nil:
    section.add "pageToken", valid_579793
  var valid_579794 = query.getOrDefault("quotaUser")
  valid_579794 = validateParameter(valid_579794, JString, required = false,
                                 default = nil)
  if valid_579794 != nil:
    section.add "quotaUser", valid_579794
  var valid_579808 = query.getOrDefault("alt")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = newJString("json"))
  if valid_579808 != nil:
    section.add "alt", valid_579808
  var valid_579809 = query.getOrDefault("namePrefix")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "namePrefix", valid_579809
  var valid_579810 = query.getOrDefault("oauth_token")
  valid_579810 = validateParameter(valid_579810, JString, required = false,
                                 default = nil)
  if valid_579810 != nil:
    section.add "oauth_token", valid_579810
  var valid_579811 = query.getOrDefault("callback")
  valid_579811 = validateParameter(valid_579811, JString, required = false,
                                 default = nil)
  if valid_579811 != nil:
    section.add "callback", valid_579811
  var valid_579812 = query.getOrDefault("access_token")
  valid_579812 = validateParameter(valid_579812, JString, required = false,
                                 default = nil)
  if valid_579812 != nil:
    section.add "access_token", valid_579812
  var valid_579813 = query.getOrDefault("uploadType")
  valid_579813 = validateParameter(valid_579813, JString, required = false,
                                 default = nil)
  if valid_579813 != nil:
    section.add "uploadType", valid_579813
  var valid_579814 = query.getOrDefault("key")
  valid_579814 = validateParameter(valid_579814, JString, required = false,
                                 default = nil)
  if valid_579814 != nil:
    section.add "key", valid_579814
  var valid_579815 = query.getOrDefault("$.xgafv")
  valid_579815 = validateParameter(valid_579815, JString, required = false,
                                 default = newJString("1"))
  if valid_579815 != nil:
    section.add "$.xgafv", valid_579815
  var valid_579816 = query.getOrDefault("pageSize")
  valid_579816 = validateParameter(valid_579816, JInt, required = false, default = nil)
  if valid_579816 != nil:
    section.add "pageSize", valid_579816
  var valid_579817 = query.getOrDefault("projectId")
  valid_579817 = validateParameter(valid_579817, JString, required = false,
                                 default = nil)
  if valid_579817 != nil:
    section.add "projectId", valid_579817
  var valid_579818 = query.getOrDefault("prettyPrint")
  valid_579818 = validateParameter(valid_579818, JBool, required = false,
                                 default = newJBool(true))
  if valid_579818 != nil:
    section.add "prettyPrint", valid_579818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579841: Call_GenomicsPipelinesList_579677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_579841.validator(path, query, header, formData, body)
  let scheme = call_579841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579841.url(scheme.get, call_579841.host, call_579841.base,
                         call_579841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579841, url, valid)

proc call*(call_579912: Call_GenomicsPipelinesList_579677;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; namePrefix: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          projectId: string = ""; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesList
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to use to indicate where to start getting results.
  ## If unspecified, returns the first page of results.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   namePrefix: string
  ##             : Pipelines with names that match this prefix should be
  ## returned.  If unspecified, all pipelines in the project, up to
  ## `pageSize`, will be returned.
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
  ##   pageSize: int
  ##           : Number of pipelines to return at once. Defaults to 256, and max
  ## is 2048.
  ##   projectId: string
  ##            : Required. The name of the project to search for pipelines. Caller
  ## must have READ access to this project.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579913 = newJObject()
  add(query_579913, "upload_protocol", newJString(uploadProtocol))
  add(query_579913, "fields", newJString(fields))
  add(query_579913, "pageToken", newJString(pageToken))
  add(query_579913, "quotaUser", newJString(quotaUser))
  add(query_579913, "alt", newJString(alt))
  add(query_579913, "namePrefix", newJString(namePrefix))
  add(query_579913, "oauth_token", newJString(oauthToken))
  add(query_579913, "callback", newJString(callback))
  add(query_579913, "access_token", newJString(accessToken))
  add(query_579913, "uploadType", newJString(uploadType))
  add(query_579913, "key", newJString(key))
  add(query_579913, "$.xgafv", newJString(Xgafv))
  add(query_579913, "pageSize", newJInt(pageSize))
  add(query_579913, "projectId", newJString(projectId))
  add(query_579913, "prettyPrint", newJBool(prettyPrint))
  result = call_579912.call(nil, query_579913, nil, nil, nil)

var genomicsPipelinesList* = Call_GenomicsPipelinesList_579677(
    name: "genomicsPipelinesList", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesList_579678, base: "/",
    url: url_GenomicsPipelinesList_579679, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGet_579972 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesGet_579974(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesGet_579973(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pipelineId: JString (required)
  ##             : Caller must have READ access to the project in which this pipeline
  ## is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pipelineId` field"
  var valid_579989 = path.getOrDefault("pipelineId")
  valid_579989 = validateParameter(valid_579989, JString, required = true,
                                 default = nil)
  if valid_579989 != nil:
    section.add "pipelineId", valid_579989
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
  var valid_579990 = query.getOrDefault("upload_protocol")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "upload_protocol", valid_579990
  var valid_579991 = query.getOrDefault("fields")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "fields", valid_579991
  var valid_579992 = query.getOrDefault("quotaUser")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "quotaUser", valid_579992
  var valid_579993 = query.getOrDefault("alt")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = newJString("json"))
  if valid_579993 != nil:
    section.add "alt", valid_579993
  var valid_579994 = query.getOrDefault("oauth_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "oauth_token", valid_579994
  var valid_579995 = query.getOrDefault("callback")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "callback", valid_579995
  var valid_579996 = query.getOrDefault("access_token")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "access_token", valid_579996
  var valid_579997 = query.getOrDefault("uploadType")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "uploadType", valid_579997
  var valid_579998 = query.getOrDefault("key")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "key", valid_579998
  var valid_579999 = query.getOrDefault("$.xgafv")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("1"))
  if valid_579999 != nil:
    section.add "$.xgafv", valid_579999
  var valid_580000 = query.getOrDefault("prettyPrint")
  valid_580000 = validateParameter(valid_580000, JBool, required = false,
                                 default = newJBool(true))
  if valid_580000 != nil:
    section.add "prettyPrint", valid_580000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580001: Call_GenomicsPipelinesGet_579972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_GenomicsPipelinesGet_579972; pipelineId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesGet
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
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
  ##   pipelineId: string (required)
  ##             : Caller must have READ access to the project in which this pipeline
  ## is defined.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(path_580003, "pipelineId", newJString(pipelineId))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  result = call_580002.call(path_580003, query_580004, nil, nil, nil)

var genomicsPipelinesGet* = Call_GenomicsPipelinesGet_579972(
    name: "genomicsPipelinesGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesGet_579973, base: "/",
    url: url_GenomicsPipelinesGet_579974, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesDelete_580005 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesDelete_580007(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesDelete_580006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   pipelineId: JString (required)
  ##             : Caller must have WRITE access to the project in which this pipeline
  ## is defined.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `pipelineId` field"
  var valid_580008 = path.getOrDefault("pipelineId")
  valid_580008 = validateParameter(valid_580008, JString, required = true,
                                 default = nil)
  if valid_580008 != nil:
    section.add "pipelineId", valid_580008
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
  var valid_580009 = query.getOrDefault("upload_protocol")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "upload_protocol", valid_580009
  var valid_580010 = query.getOrDefault("fields")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "fields", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("alt")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("json"))
  if valid_580012 != nil:
    section.add "alt", valid_580012
  var valid_580013 = query.getOrDefault("oauth_token")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "oauth_token", valid_580013
  var valid_580014 = query.getOrDefault("callback")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "callback", valid_580014
  var valid_580015 = query.getOrDefault("access_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "access_token", valid_580015
  var valid_580016 = query.getOrDefault("uploadType")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "uploadType", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  var valid_580018 = query.getOrDefault("$.xgafv")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("1"))
  if valid_580018 != nil:
    section.add "$.xgafv", valid_580018
  var valid_580019 = query.getOrDefault("prettyPrint")
  valid_580019 = validateParameter(valid_580019, JBool, required = false,
                                 default = newJBool(true))
  if valid_580019 != nil:
    section.add "prettyPrint", valid_580019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580020: Call_GenomicsPipelinesDelete_580005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_580020.validator(path, query, header, formData, body)
  let scheme = call_580020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580020.url(scheme.get, call_580020.host, call_580020.base,
                         call_580020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580020, url, valid)

proc call*(call_580021: Call_GenomicsPipelinesDelete_580005; pipelineId: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesDelete
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
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
  ##   pipelineId: string (required)
  ##             : Caller must have WRITE access to the project in which this pipeline
  ## is defined.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580022 = newJObject()
  var query_580023 = newJObject()
  add(query_580023, "upload_protocol", newJString(uploadProtocol))
  add(query_580023, "fields", newJString(fields))
  add(query_580023, "quotaUser", newJString(quotaUser))
  add(query_580023, "alt", newJString(alt))
  add(query_580023, "oauth_token", newJString(oauthToken))
  add(query_580023, "callback", newJString(callback))
  add(query_580023, "access_token", newJString(accessToken))
  add(query_580023, "uploadType", newJString(uploadType))
  add(path_580022, "pipelineId", newJString(pipelineId))
  add(query_580023, "key", newJString(key))
  add(query_580023, "$.xgafv", newJString(Xgafv))
  add(query_580023, "prettyPrint", newJBool(prettyPrint))
  result = call_580021.call(path_580022, query_580023, nil, nil, nil)

var genomicsPipelinesDelete* = Call_GenomicsPipelinesDelete_580005(
    name: "genomicsPipelinesDelete", meth: HttpMethod.HttpDelete,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesDelete_580006, base: "/",
    url: url_GenomicsPipelinesDelete_580007, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGetControllerConfig_580024 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesGetControllerConfig_580026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesGetControllerConfig_580025(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validationToken: JString
  ##   alt: JString
  ##      : Data format for response.
  ##   operationId: JString
  ##              : The operation to retrieve controller configuration for.
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
  var valid_580027 = query.getOrDefault("upload_protocol")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "upload_protocol", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
  var valid_580029 = query.getOrDefault("quotaUser")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "quotaUser", valid_580029
  var valid_580030 = query.getOrDefault("validationToken")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "validationToken", valid_580030
  var valid_580031 = query.getOrDefault("alt")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("json"))
  if valid_580031 != nil:
    section.add "alt", valid_580031
  var valid_580032 = query.getOrDefault("operationId")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "operationId", valid_580032
  var valid_580033 = query.getOrDefault("oauth_token")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "oauth_token", valid_580033
  var valid_580034 = query.getOrDefault("callback")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "callback", valid_580034
  var valid_580035 = query.getOrDefault("access_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "access_token", valid_580035
  var valid_580036 = query.getOrDefault("uploadType")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "uploadType", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("$.xgafv")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = newJString("1"))
  if valid_580038 != nil:
    section.add "$.xgafv", valid_580038
  var valid_580039 = query.getOrDefault("prettyPrint")
  valid_580039 = validateParameter(valid_580039, JBool, required = false,
                                 default = newJBool(true))
  if valid_580039 != nil:
    section.add "prettyPrint", valid_580039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580040: Call_GenomicsPipelinesGetControllerConfig_580024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ## 
  let valid = call_580040.validator(path, query, header, formData, body)
  let scheme = call_580040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580040.url(scheme.get, call_580040.host, call_580040.base,
                         call_580040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580040, url, valid)

proc call*(call_580041: Call_GenomicsPipelinesGetControllerConfig_580024;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          validationToken: string = ""; alt: string = "json"; operationId: string = "";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesGetControllerConfig
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   validationToken: string
  ##   alt: string
  ##      : Data format for response.
  ##   operationId: string
  ##              : The operation to retrieve controller configuration for.
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
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580042 = newJObject()
  add(query_580042, "upload_protocol", newJString(uploadProtocol))
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "validationToken", newJString(validationToken))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "operationId", newJString(operationId))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "callback", newJString(callback))
  add(query_580042, "access_token", newJString(accessToken))
  add(query_580042, "uploadType", newJString(uploadType))
  add(query_580042, "key", newJString(key))
  add(query_580042, "$.xgafv", newJString(Xgafv))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580041.call(nil, query_580042, nil, nil, nil)

var genomicsPipelinesGetControllerConfig* = Call_GenomicsPipelinesGetControllerConfig_580024(
    name: "genomicsPipelinesGetControllerConfig", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:getControllerConfig",
    validator: validate_GenomicsPipelinesGetControllerConfig_580025, base: "/",
    url: url_GenomicsPipelinesGetControllerConfig_580026, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesRun_580043 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesRun_580045(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesRun_580044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580046 = query.getOrDefault("upload_protocol")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "upload_protocol", valid_580046
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("callback")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "callback", valid_580051
  var valid_580052 = query.getOrDefault("access_token")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "access_token", valid_580052
  var valid_580053 = query.getOrDefault("uploadType")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "uploadType", valid_580053
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("$.xgafv")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = newJString("1"))
  if valid_580055 != nil:
    section.add "$.xgafv", valid_580055
  var valid_580056 = query.getOrDefault("prettyPrint")
  valid_580056 = validateParameter(valid_580056, JBool, required = false,
                                 default = newJBool(true))
  if valid_580056 != nil:
    section.add "prettyPrint", valid_580056
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

proc call*(call_580058: Call_GenomicsPipelinesRun_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
  ## 
  let valid = call_580058.validator(path, query, header, formData, body)
  let scheme = call_580058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580058.url(scheme.get, call_580058.host, call_580058.base,
                         call_580058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580058, url, valid)

proc call*(call_580059: Call_GenomicsPipelinesRun_580043;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesRun
  ## Runs a pipeline. If `pipelineId` is specified in the request, then
  ## run a saved pipeline. If `ephemeralPipeline` is specified, then run
  ## that pipeline once without saving a copy.
  ## 
  ## The caller must have READ permission to the project where the pipeline
  ## is stored and WRITE permission to the project where the pipeline will be
  ## run, as VMs will be created and storage will be used.
  ## 
  ## If a pipeline operation is still running after 6 days, it will be canceled.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580060 = newJObject()
  var body_580061 = newJObject()
  add(query_580060, "upload_protocol", newJString(uploadProtocol))
  add(query_580060, "fields", newJString(fields))
  add(query_580060, "quotaUser", newJString(quotaUser))
  add(query_580060, "alt", newJString(alt))
  add(query_580060, "oauth_token", newJString(oauthToken))
  add(query_580060, "callback", newJString(callback))
  add(query_580060, "access_token", newJString(accessToken))
  add(query_580060, "uploadType", newJString(uploadType))
  add(query_580060, "key", newJString(key))
  add(query_580060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580061 = body
  add(query_580060, "prettyPrint", newJBool(prettyPrint))
  result = call_580059.call(nil, query_580060, nil, nil, body_580061)

var genomicsPipelinesRun* = Call_GenomicsPipelinesRun_580043(
    name: "genomicsPipelinesRun", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines:run",
    validator: validate_GenomicsPipelinesRun_580044, base: "/",
    url: url_GenomicsPipelinesRun_580045, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesSetOperationStatus_580062 = ref object of OpenApiRestCall_579408
proc url_GenomicsPipelinesSetOperationStatus_580064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesSetOperationStatus_580063(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
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
  var valid_580065 = query.getOrDefault("upload_protocol")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "upload_protocol", valid_580065
  var valid_580066 = query.getOrDefault("fields")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "fields", valid_580066
  var valid_580067 = query.getOrDefault("quotaUser")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = nil)
  if valid_580067 != nil:
    section.add "quotaUser", valid_580067
  var valid_580068 = query.getOrDefault("alt")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = newJString("json"))
  if valid_580068 != nil:
    section.add "alt", valid_580068
  var valid_580069 = query.getOrDefault("oauth_token")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "oauth_token", valid_580069
  var valid_580070 = query.getOrDefault("callback")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "callback", valid_580070
  var valid_580071 = query.getOrDefault("access_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "access_token", valid_580071
  var valid_580072 = query.getOrDefault("uploadType")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "uploadType", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("$.xgafv")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("1"))
  if valid_580074 != nil:
    section.add "$.xgafv", valid_580074
  var valid_580075 = query.getOrDefault("prettyPrint")
  valid_580075 = validateParameter(valid_580075, JBool, required = false,
                                 default = newJBool(true))
  if valid_580075 != nil:
    section.add "prettyPrint", valid_580075
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

proc call*(call_580077: Call_GenomicsPipelinesSetOperationStatus_580062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
  ## 
  let valid = call_580077.validator(path, query, header, formData, body)
  let scheme = call_580077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580077.url(scheme.get, call_580077.host, call_580077.base,
                         call_580077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580077, url, valid)

proc call*(call_580078: Call_GenomicsPipelinesSetOperationStatus_580062;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## genomicsPipelinesSetOperationStatus
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580079 = newJObject()
  var body_580080 = newJObject()
  add(query_580079, "upload_protocol", newJString(uploadProtocol))
  add(query_580079, "fields", newJString(fields))
  add(query_580079, "quotaUser", newJString(quotaUser))
  add(query_580079, "alt", newJString(alt))
  add(query_580079, "oauth_token", newJString(oauthToken))
  add(query_580079, "callback", newJString(callback))
  add(query_580079, "access_token", newJString(accessToken))
  add(query_580079, "uploadType", newJString(uploadType))
  add(query_580079, "key", newJString(key))
  add(query_580079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580080 = body
  add(query_580079, "prettyPrint", newJBool(prettyPrint))
  result = call_580078.call(nil, query_580079, nil, nil, body_580080)

var genomicsPipelinesSetOperationStatus* = Call_GenomicsPipelinesSetOperationStatus_580062(
    name: "genomicsPipelinesSetOperationStatus", meth: HttpMethod.HttpPut,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:setOperationStatus",
    validator: validate_GenomicsPipelinesSetOperationStatus_580063, base: "/",
    url: url_GenomicsPipelinesSetOperationStatus_580064, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsGet_580081 = ref object of OpenApiRestCall_579408
proc url_GenomicsOperationsGet_580083(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsOperationsGet_580082(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580084 = path.getOrDefault("name")
  valid_580084 = validateParameter(valid_580084, JString, required = true,
                                 default = nil)
  if valid_580084 != nil:
    section.add "name", valid_580084
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
  var valid_580085 = query.getOrDefault("upload_protocol")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "upload_protocol", valid_580085
  var valid_580086 = query.getOrDefault("fields")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = nil)
  if valid_580086 != nil:
    section.add "fields", valid_580086
  var valid_580087 = query.getOrDefault("quotaUser")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "quotaUser", valid_580087
  var valid_580088 = query.getOrDefault("alt")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = newJString("json"))
  if valid_580088 != nil:
    section.add "alt", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("callback")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "callback", valid_580090
  var valid_580091 = query.getOrDefault("access_token")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "access_token", valid_580091
  var valid_580092 = query.getOrDefault("uploadType")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "uploadType", valid_580092
  var valid_580093 = query.getOrDefault("key")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "key", valid_580093
  var valid_580094 = query.getOrDefault("$.xgafv")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("1"))
  if valid_580094 != nil:
    section.add "$.xgafv", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580096: Call_GenomicsOperationsGet_580081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  let valid = call_580096.validator(path, query, header, formData, body)
  let scheme = call_580096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580096.url(scheme.get, call_580096.host, call_580096.base,
                         call_580096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580096, url, valid)

proc call*(call_580097: Call_GenomicsOperationsGet_580081; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## genomicsOperationsGet
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580098 = newJObject()
  var query_580099 = newJObject()
  add(query_580099, "upload_protocol", newJString(uploadProtocol))
  add(query_580099, "fields", newJString(fields))
  add(query_580099, "quotaUser", newJString(quotaUser))
  add(path_580098, "name", newJString(name))
  add(query_580099, "alt", newJString(alt))
  add(query_580099, "oauth_token", newJString(oauthToken))
  add(query_580099, "callback", newJString(callback))
  add(query_580099, "access_token", newJString(accessToken))
  add(query_580099, "uploadType", newJString(uploadType))
  add(query_580099, "key", newJString(key))
  add(query_580099, "$.xgafv", newJString(Xgafv))
  add(query_580099, "prettyPrint", newJBool(prettyPrint))
  result = call_580097.call(path_580098, query_580099, nil, nil, nil)

var genomicsOperationsGet* = Call_GenomicsOperationsGet_580081(
    name: "genomicsOperationsGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}",
    validator: validate_GenomicsOperationsGet_580082, base: "/",
    url: url_GenomicsOperationsGet_580083, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsCancel_580100 = ref object of OpenApiRestCall_579408
proc url_GenomicsOperationsCancel_580102(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsOperationsCancel_580101(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580103 = path.getOrDefault("name")
  valid_580103 = validateParameter(valid_580103, JString, required = true,
                                 default = nil)
  if valid_580103 != nil:
    section.add "name", valid_580103
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
  var valid_580104 = query.getOrDefault("upload_protocol")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "upload_protocol", valid_580104
  var valid_580105 = query.getOrDefault("fields")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "fields", valid_580105
  var valid_580106 = query.getOrDefault("quotaUser")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "quotaUser", valid_580106
  var valid_580107 = query.getOrDefault("alt")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = newJString("json"))
  if valid_580107 != nil:
    section.add "alt", valid_580107
  var valid_580108 = query.getOrDefault("oauth_token")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "oauth_token", valid_580108
  var valid_580109 = query.getOrDefault("callback")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "callback", valid_580109
  var valid_580110 = query.getOrDefault("access_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "access_token", valid_580110
  var valid_580111 = query.getOrDefault("uploadType")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "uploadType", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("$.xgafv")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = newJString("1"))
  if valid_580113 != nil:
    section.add "$.xgafv", valid_580113
  var valid_580114 = query.getOrDefault("prettyPrint")
  valid_580114 = validateParameter(valid_580114, JBool, required = false,
                                 default = newJBool(true))
  if valid_580114 != nil:
    section.add "prettyPrint", valid_580114
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

proc call*(call_580116: Call_GenomicsOperationsCancel_580100; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_GenomicsOperationsCancel_580100; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## genomicsOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.
  ## The server makes a best effort to cancel the operation, but success is not
  ## guaranteed. Clients may use Operations.GetOperation
  ## or Operations.ListOperations
  ## to check whether the cancellation succeeded or the operation completed
  ## despite cancellation.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.cancel`
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
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
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580118 = newJObject()
  var query_580119 = newJObject()
  var body_580120 = newJObject()
  add(query_580119, "upload_protocol", newJString(uploadProtocol))
  add(query_580119, "fields", newJString(fields))
  add(query_580119, "quotaUser", newJString(quotaUser))
  add(path_580118, "name", newJString(name))
  add(query_580119, "alt", newJString(alt))
  add(query_580119, "oauth_token", newJString(oauthToken))
  add(query_580119, "callback", newJString(callback))
  add(query_580119, "access_token", newJString(accessToken))
  add(query_580119, "uploadType", newJString(uploadType))
  add(query_580119, "key", newJString(key))
  add(query_580119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580120 = body
  add(query_580119, "prettyPrint", newJBool(prettyPrint))
  result = call_580117.call(path_580118, query_580119, nil, nil, body_580120)

var genomicsOperationsCancel* = Call_GenomicsOperationsCancel_580100(
    name: "genomicsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}:cancel",
    validator: validate_GenomicsOperationsCancel_580101, base: "/",
    url: url_GenomicsOperationsCancel_580102, schemes: {Scheme.Https})
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
