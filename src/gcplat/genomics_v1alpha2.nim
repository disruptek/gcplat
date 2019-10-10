
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
  gcpServiceName = "genomics"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GenomicsPipelinesCreate_588986 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesCreate_588988(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesCreate_588987(path: JsonNode; query: JsonNode;
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
  var valid_588989 = query.getOrDefault("upload_protocol")
  valid_588989 = validateParameter(valid_588989, JString, required = false,
                                 default = nil)
  if valid_588989 != nil:
    section.add "upload_protocol", valid_588989
  var valid_588990 = query.getOrDefault("fields")
  valid_588990 = validateParameter(valid_588990, JString, required = false,
                                 default = nil)
  if valid_588990 != nil:
    section.add "fields", valid_588990
  var valid_588991 = query.getOrDefault("quotaUser")
  valid_588991 = validateParameter(valid_588991, JString, required = false,
                                 default = nil)
  if valid_588991 != nil:
    section.add "quotaUser", valid_588991
  var valid_588992 = query.getOrDefault("alt")
  valid_588992 = validateParameter(valid_588992, JString, required = false,
                                 default = newJString("json"))
  if valid_588992 != nil:
    section.add "alt", valid_588992
  var valid_588993 = query.getOrDefault("oauth_token")
  valid_588993 = validateParameter(valid_588993, JString, required = false,
                                 default = nil)
  if valid_588993 != nil:
    section.add "oauth_token", valid_588993
  var valid_588994 = query.getOrDefault("callback")
  valid_588994 = validateParameter(valid_588994, JString, required = false,
                                 default = nil)
  if valid_588994 != nil:
    section.add "callback", valid_588994
  var valid_588995 = query.getOrDefault("access_token")
  valid_588995 = validateParameter(valid_588995, JString, required = false,
                                 default = nil)
  if valid_588995 != nil:
    section.add "access_token", valid_588995
  var valid_588996 = query.getOrDefault("uploadType")
  valid_588996 = validateParameter(valid_588996, JString, required = false,
                                 default = nil)
  if valid_588996 != nil:
    section.add "uploadType", valid_588996
  var valid_588997 = query.getOrDefault("key")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "key", valid_588997
  var valid_588998 = query.getOrDefault("$.xgafv")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = newJString("1"))
  if valid_588998 != nil:
    section.add "$.xgafv", valid_588998
  var valid_588999 = query.getOrDefault("prettyPrint")
  valid_588999 = validateParameter(valid_588999, JBool, required = false,
                                 default = newJBool(true))
  if valid_588999 != nil:
    section.add "prettyPrint", valid_588999
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

proc call*(call_589001: Call_GenomicsPipelinesCreate_588986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_589001.validator(path, query, header, formData, body)
  let scheme = call_589001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589001.url(scheme.get, call_589001.host, call_589001.base,
                         call_589001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589001, url, valid)

proc call*(call_589002: Call_GenomicsPipelinesCreate_588986;
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
  var query_589003 = newJObject()
  var body_589004 = newJObject()
  add(query_589003, "upload_protocol", newJString(uploadProtocol))
  add(query_589003, "fields", newJString(fields))
  add(query_589003, "quotaUser", newJString(quotaUser))
  add(query_589003, "alt", newJString(alt))
  add(query_589003, "oauth_token", newJString(oauthToken))
  add(query_589003, "callback", newJString(callback))
  add(query_589003, "access_token", newJString(accessToken))
  add(query_589003, "uploadType", newJString(uploadType))
  add(query_589003, "key", newJString(key))
  add(query_589003, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589004 = body
  add(query_589003, "prettyPrint", newJBool(prettyPrint))
  result = call_589002.call(nil, query_589003, nil, nil, body_589004)

var genomicsPipelinesCreate* = Call_GenomicsPipelinesCreate_588986(
    name: "genomicsPipelinesCreate", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesCreate_588987, base: "/",
    url: url_GenomicsPipelinesCreate_588988, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesList_588710 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesList_588712(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesList_588711(path: JsonNode; query: JsonNode;
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
  var valid_588824 = query.getOrDefault("upload_protocol")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "upload_protocol", valid_588824
  var valid_588825 = query.getOrDefault("fields")
  valid_588825 = validateParameter(valid_588825, JString, required = false,
                                 default = nil)
  if valid_588825 != nil:
    section.add "fields", valid_588825
  var valid_588826 = query.getOrDefault("pageToken")
  valid_588826 = validateParameter(valid_588826, JString, required = false,
                                 default = nil)
  if valid_588826 != nil:
    section.add "pageToken", valid_588826
  var valid_588827 = query.getOrDefault("quotaUser")
  valid_588827 = validateParameter(valid_588827, JString, required = false,
                                 default = nil)
  if valid_588827 != nil:
    section.add "quotaUser", valid_588827
  var valid_588841 = query.getOrDefault("alt")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = newJString("json"))
  if valid_588841 != nil:
    section.add "alt", valid_588841
  var valid_588842 = query.getOrDefault("namePrefix")
  valid_588842 = validateParameter(valid_588842, JString, required = false,
                                 default = nil)
  if valid_588842 != nil:
    section.add "namePrefix", valid_588842
  var valid_588843 = query.getOrDefault("oauth_token")
  valid_588843 = validateParameter(valid_588843, JString, required = false,
                                 default = nil)
  if valid_588843 != nil:
    section.add "oauth_token", valid_588843
  var valid_588844 = query.getOrDefault("callback")
  valid_588844 = validateParameter(valid_588844, JString, required = false,
                                 default = nil)
  if valid_588844 != nil:
    section.add "callback", valid_588844
  var valid_588845 = query.getOrDefault("access_token")
  valid_588845 = validateParameter(valid_588845, JString, required = false,
                                 default = nil)
  if valid_588845 != nil:
    section.add "access_token", valid_588845
  var valid_588846 = query.getOrDefault("uploadType")
  valid_588846 = validateParameter(valid_588846, JString, required = false,
                                 default = nil)
  if valid_588846 != nil:
    section.add "uploadType", valid_588846
  var valid_588847 = query.getOrDefault("key")
  valid_588847 = validateParameter(valid_588847, JString, required = false,
                                 default = nil)
  if valid_588847 != nil:
    section.add "key", valid_588847
  var valid_588848 = query.getOrDefault("$.xgafv")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = newJString("1"))
  if valid_588848 != nil:
    section.add "$.xgafv", valid_588848
  var valid_588849 = query.getOrDefault("pageSize")
  valid_588849 = validateParameter(valid_588849, JInt, required = false, default = nil)
  if valid_588849 != nil:
    section.add "pageSize", valid_588849
  var valid_588850 = query.getOrDefault("projectId")
  valid_588850 = validateParameter(valid_588850, JString, required = false,
                                 default = nil)
  if valid_588850 != nil:
    section.add "projectId", valid_588850
  var valid_588851 = query.getOrDefault("prettyPrint")
  valid_588851 = validateParameter(valid_588851, JBool, required = false,
                                 default = newJBool(true))
  if valid_588851 != nil:
    section.add "prettyPrint", valid_588851
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588874: Call_GenomicsPipelinesList_588710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_588874.validator(path, query, header, formData, body)
  let scheme = call_588874.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588874.url(scheme.get, call_588874.host, call_588874.base,
                         call_588874.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588874, url, valid)

proc call*(call_588945: Call_GenomicsPipelinesList_588710;
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
  var query_588946 = newJObject()
  add(query_588946, "upload_protocol", newJString(uploadProtocol))
  add(query_588946, "fields", newJString(fields))
  add(query_588946, "pageToken", newJString(pageToken))
  add(query_588946, "quotaUser", newJString(quotaUser))
  add(query_588946, "alt", newJString(alt))
  add(query_588946, "namePrefix", newJString(namePrefix))
  add(query_588946, "oauth_token", newJString(oauthToken))
  add(query_588946, "callback", newJString(callback))
  add(query_588946, "access_token", newJString(accessToken))
  add(query_588946, "uploadType", newJString(uploadType))
  add(query_588946, "key", newJString(key))
  add(query_588946, "$.xgafv", newJString(Xgafv))
  add(query_588946, "pageSize", newJInt(pageSize))
  add(query_588946, "projectId", newJString(projectId))
  add(query_588946, "prettyPrint", newJBool(prettyPrint))
  result = call_588945.call(nil, query_588946, nil, nil, nil)

var genomicsPipelinesList* = Call_GenomicsPipelinesList_588710(
    name: "genomicsPipelinesList", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesList_588711, base: "/",
    url: url_GenomicsPipelinesList_588712, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGet_589005 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesGet_589007(protocol: Scheme; host: string; base: string;
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

proc validate_GenomicsPipelinesGet_589006(path: JsonNode; query: JsonNode;
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
  var valid_589022 = path.getOrDefault("pipelineId")
  valid_589022 = validateParameter(valid_589022, JString, required = true,
                                 default = nil)
  if valid_589022 != nil:
    section.add "pipelineId", valid_589022
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
  var valid_589023 = query.getOrDefault("upload_protocol")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "upload_protocol", valid_589023
  var valid_589024 = query.getOrDefault("fields")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "fields", valid_589024
  var valid_589025 = query.getOrDefault("quotaUser")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "quotaUser", valid_589025
  var valid_589026 = query.getOrDefault("alt")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = newJString("json"))
  if valid_589026 != nil:
    section.add "alt", valid_589026
  var valid_589027 = query.getOrDefault("oauth_token")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "oauth_token", valid_589027
  var valid_589028 = query.getOrDefault("callback")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "callback", valid_589028
  var valid_589029 = query.getOrDefault("access_token")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "access_token", valid_589029
  var valid_589030 = query.getOrDefault("uploadType")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "uploadType", valid_589030
  var valid_589031 = query.getOrDefault("key")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "key", valid_589031
  var valid_589032 = query.getOrDefault("$.xgafv")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("1"))
  if valid_589032 != nil:
    section.add "$.xgafv", valid_589032
  var valid_589033 = query.getOrDefault("prettyPrint")
  valid_589033 = validateParameter(valid_589033, JBool, required = false,
                                 default = newJBool(true))
  if valid_589033 != nil:
    section.add "prettyPrint", valid_589033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589034: Call_GenomicsPipelinesGet_589005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_589034.validator(path, query, header, formData, body)
  let scheme = call_589034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589034.url(scheme.get, call_589034.host, call_589034.base,
                         call_589034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589034, url, valid)

proc call*(call_589035: Call_GenomicsPipelinesGet_589005; pipelineId: string;
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
  var path_589036 = newJObject()
  var query_589037 = newJObject()
  add(query_589037, "upload_protocol", newJString(uploadProtocol))
  add(query_589037, "fields", newJString(fields))
  add(query_589037, "quotaUser", newJString(quotaUser))
  add(query_589037, "alt", newJString(alt))
  add(query_589037, "oauth_token", newJString(oauthToken))
  add(query_589037, "callback", newJString(callback))
  add(query_589037, "access_token", newJString(accessToken))
  add(query_589037, "uploadType", newJString(uploadType))
  add(path_589036, "pipelineId", newJString(pipelineId))
  add(query_589037, "key", newJString(key))
  add(query_589037, "$.xgafv", newJString(Xgafv))
  add(query_589037, "prettyPrint", newJBool(prettyPrint))
  result = call_589035.call(path_589036, query_589037, nil, nil, nil)

var genomicsPipelinesGet* = Call_GenomicsPipelinesGet_589005(
    name: "genomicsPipelinesGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesGet_589006, base: "/",
    url: url_GenomicsPipelinesGet_589007, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesDelete_589038 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesDelete_589040(protocol: Scheme; host: string; base: string;
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

proc validate_GenomicsPipelinesDelete_589039(path: JsonNode; query: JsonNode;
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
  var valid_589041 = path.getOrDefault("pipelineId")
  valid_589041 = validateParameter(valid_589041, JString, required = true,
                                 default = nil)
  if valid_589041 != nil:
    section.add "pipelineId", valid_589041
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
  var valid_589042 = query.getOrDefault("upload_protocol")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "upload_protocol", valid_589042
  var valid_589043 = query.getOrDefault("fields")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "fields", valid_589043
  var valid_589044 = query.getOrDefault("quotaUser")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "quotaUser", valid_589044
  var valid_589045 = query.getOrDefault("alt")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = newJString("json"))
  if valid_589045 != nil:
    section.add "alt", valid_589045
  var valid_589046 = query.getOrDefault("oauth_token")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "oauth_token", valid_589046
  var valid_589047 = query.getOrDefault("callback")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "callback", valid_589047
  var valid_589048 = query.getOrDefault("access_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "access_token", valid_589048
  var valid_589049 = query.getOrDefault("uploadType")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "uploadType", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  var valid_589051 = query.getOrDefault("$.xgafv")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = newJString("1"))
  if valid_589051 != nil:
    section.add "$.xgafv", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589053: Call_GenomicsPipelinesDelete_589038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_589053.validator(path, query, header, formData, body)
  let scheme = call_589053.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589053.url(scheme.get, call_589053.host, call_589053.base,
                         call_589053.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589053, url, valid)

proc call*(call_589054: Call_GenomicsPipelinesDelete_589038; pipelineId: string;
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
  var path_589055 = newJObject()
  var query_589056 = newJObject()
  add(query_589056, "upload_protocol", newJString(uploadProtocol))
  add(query_589056, "fields", newJString(fields))
  add(query_589056, "quotaUser", newJString(quotaUser))
  add(query_589056, "alt", newJString(alt))
  add(query_589056, "oauth_token", newJString(oauthToken))
  add(query_589056, "callback", newJString(callback))
  add(query_589056, "access_token", newJString(accessToken))
  add(query_589056, "uploadType", newJString(uploadType))
  add(path_589055, "pipelineId", newJString(pipelineId))
  add(query_589056, "key", newJString(key))
  add(query_589056, "$.xgafv", newJString(Xgafv))
  add(query_589056, "prettyPrint", newJBool(prettyPrint))
  result = call_589054.call(path_589055, query_589056, nil, nil, nil)

var genomicsPipelinesDelete* = Call_GenomicsPipelinesDelete_589038(
    name: "genomicsPipelinesDelete", meth: HttpMethod.HttpDelete,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesDelete_589039, base: "/",
    url: url_GenomicsPipelinesDelete_589040, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGetControllerConfig_589057 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesGetControllerConfig_589059(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesGetControllerConfig_589058(path: JsonNode;
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
  var valid_589060 = query.getOrDefault("upload_protocol")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "upload_protocol", valid_589060
  var valid_589061 = query.getOrDefault("fields")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "fields", valid_589061
  var valid_589062 = query.getOrDefault("quotaUser")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = nil)
  if valid_589062 != nil:
    section.add "quotaUser", valid_589062
  var valid_589063 = query.getOrDefault("validationToken")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "validationToken", valid_589063
  var valid_589064 = query.getOrDefault("alt")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = newJString("json"))
  if valid_589064 != nil:
    section.add "alt", valid_589064
  var valid_589065 = query.getOrDefault("operationId")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "operationId", valid_589065
  var valid_589066 = query.getOrDefault("oauth_token")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "oauth_token", valid_589066
  var valid_589067 = query.getOrDefault("callback")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "callback", valid_589067
  var valid_589068 = query.getOrDefault("access_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "access_token", valid_589068
  var valid_589069 = query.getOrDefault("uploadType")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "uploadType", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("$.xgafv")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = newJString("1"))
  if valid_589071 != nil:
    section.add "$.xgafv", valid_589071
  var valid_589072 = query.getOrDefault("prettyPrint")
  valid_589072 = validateParameter(valid_589072, JBool, required = false,
                                 default = newJBool(true))
  if valid_589072 != nil:
    section.add "prettyPrint", valid_589072
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589073: Call_GenomicsPipelinesGetControllerConfig_589057;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ## 
  let valid = call_589073.validator(path, query, header, formData, body)
  let scheme = call_589073.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589073.url(scheme.get, call_589073.host, call_589073.base,
                         call_589073.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589073, url, valid)

proc call*(call_589074: Call_GenomicsPipelinesGetControllerConfig_589057;
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
  var query_589075 = newJObject()
  add(query_589075, "upload_protocol", newJString(uploadProtocol))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "validationToken", newJString(validationToken))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "operationId", newJString(operationId))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "callback", newJString(callback))
  add(query_589075, "access_token", newJString(accessToken))
  add(query_589075, "uploadType", newJString(uploadType))
  add(query_589075, "key", newJString(key))
  add(query_589075, "$.xgafv", newJString(Xgafv))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589074.call(nil, query_589075, nil, nil, nil)

var genomicsPipelinesGetControllerConfig* = Call_GenomicsPipelinesGetControllerConfig_589057(
    name: "genomicsPipelinesGetControllerConfig", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:getControllerConfig",
    validator: validate_GenomicsPipelinesGetControllerConfig_589058, base: "/",
    url: url_GenomicsPipelinesGetControllerConfig_589059, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesRun_589076 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesRun_589078(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesRun_589077(path: JsonNode; query: JsonNode;
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
  var valid_589079 = query.getOrDefault("upload_protocol")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "upload_protocol", valid_589079
  var valid_589080 = query.getOrDefault("fields")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "fields", valid_589080
  var valid_589081 = query.getOrDefault("quotaUser")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "quotaUser", valid_589081
  var valid_589082 = query.getOrDefault("alt")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("json"))
  if valid_589082 != nil:
    section.add "alt", valid_589082
  var valid_589083 = query.getOrDefault("oauth_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "oauth_token", valid_589083
  var valid_589084 = query.getOrDefault("callback")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "callback", valid_589084
  var valid_589085 = query.getOrDefault("access_token")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "access_token", valid_589085
  var valid_589086 = query.getOrDefault("uploadType")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "uploadType", valid_589086
  var valid_589087 = query.getOrDefault("key")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "key", valid_589087
  var valid_589088 = query.getOrDefault("$.xgafv")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = newJString("1"))
  if valid_589088 != nil:
    section.add "$.xgafv", valid_589088
  var valid_589089 = query.getOrDefault("prettyPrint")
  valid_589089 = validateParameter(valid_589089, JBool, required = false,
                                 default = newJBool(true))
  if valid_589089 != nil:
    section.add "prettyPrint", valid_589089
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

proc call*(call_589091: Call_GenomicsPipelinesRun_589076; path: JsonNode;
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
  let valid = call_589091.validator(path, query, header, formData, body)
  let scheme = call_589091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589091.url(scheme.get, call_589091.host, call_589091.base,
                         call_589091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589091, url, valid)

proc call*(call_589092: Call_GenomicsPipelinesRun_589076;
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
  var query_589093 = newJObject()
  var body_589094 = newJObject()
  add(query_589093, "upload_protocol", newJString(uploadProtocol))
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(query_589093, "alt", newJString(alt))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "callback", newJString(callback))
  add(query_589093, "access_token", newJString(accessToken))
  add(query_589093, "uploadType", newJString(uploadType))
  add(query_589093, "key", newJString(key))
  add(query_589093, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589094 = body
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  result = call_589092.call(nil, query_589093, nil, nil, body_589094)

var genomicsPipelinesRun* = Call_GenomicsPipelinesRun_589076(
    name: "genomicsPipelinesRun", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines:run",
    validator: validate_GenomicsPipelinesRun_589077, base: "/",
    url: url_GenomicsPipelinesRun_589078, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesSetOperationStatus_589095 = ref object of OpenApiRestCall_588441
proc url_GenomicsPipelinesSetOperationStatus_589097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesSetOperationStatus_589096(path: JsonNode;
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
  var valid_589098 = query.getOrDefault("upload_protocol")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "upload_protocol", valid_589098
  var valid_589099 = query.getOrDefault("fields")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "fields", valid_589099
  var valid_589100 = query.getOrDefault("quotaUser")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "quotaUser", valid_589100
  var valid_589101 = query.getOrDefault("alt")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = newJString("json"))
  if valid_589101 != nil:
    section.add "alt", valid_589101
  var valid_589102 = query.getOrDefault("oauth_token")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "oauth_token", valid_589102
  var valid_589103 = query.getOrDefault("callback")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "callback", valid_589103
  var valid_589104 = query.getOrDefault("access_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "access_token", valid_589104
  var valid_589105 = query.getOrDefault("uploadType")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "uploadType", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("$.xgafv")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = newJString("1"))
  if valid_589107 != nil:
    section.add "$.xgafv", valid_589107
  var valid_589108 = query.getOrDefault("prettyPrint")
  valid_589108 = validateParameter(valid_589108, JBool, required = false,
                                 default = newJBool(true))
  if valid_589108 != nil:
    section.add "prettyPrint", valid_589108
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

proc call*(call_589110: Call_GenomicsPipelinesSetOperationStatus_589095;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
  ## 
  let valid = call_589110.validator(path, query, header, formData, body)
  let scheme = call_589110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589110.url(scheme.get, call_589110.host, call_589110.base,
                         call_589110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589110, url, valid)

proc call*(call_589111: Call_GenomicsPipelinesSetOperationStatus_589095;
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
  var query_589112 = newJObject()
  var body_589113 = newJObject()
  add(query_589112, "upload_protocol", newJString(uploadProtocol))
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "quotaUser", newJString(quotaUser))
  add(query_589112, "alt", newJString(alt))
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "callback", newJString(callback))
  add(query_589112, "access_token", newJString(accessToken))
  add(query_589112, "uploadType", newJString(uploadType))
  add(query_589112, "key", newJString(key))
  add(query_589112, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589113 = body
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  result = call_589111.call(nil, query_589112, nil, nil, body_589113)

var genomicsPipelinesSetOperationStatus* = Call_GenomicsPipelinesSetOperationStatus_589095(
    name: "genomicsPipelinesSetOperationStatus", meth: HttpMethod.HttpPut,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:setOperationStatus",
    validator: validate_GenomicsPipelinesSetOperationStatus_589096, base: "/",
    url: url_GenomicsPipelinesSetOperationStatus_589097, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsGet_589114 = ref object of OpenApiRestCall_588441
proc url_GenomicsOperationsGet_589116(protocol: Scheme; host: string; base: string;
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

proc validate_GenomicsOperationsGet_589115(path: JsonNode; query: JsonNode;
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
  var valid_589117 = path.getOrDefault("name")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "name", valid_589117
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
  var valid_589118 = query.getOrDefault("upload_protocol")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "upload_protocol", valid_589118
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("callback")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "callback", valid_589123
  var valid_589124 = query.getOrDefault("access_token")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "access_token", valid_589124
  var valid_589125 = query.getOrDefault("uploadType")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "uploadType", valid_589125
  var valid_589126 = query.getOrDefault("key")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "key", valid_589126
  var valid_589127 = query.getOrDefault("$.xgafv")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("1"))
  if valid_589127 != nil:
    section.add "$.xgafv", valid_589127
  var valid_589128 = query.getOrDefault("prettyPrint")
  valid_589128 = validateParameter(valid_589128, JBool, required = false,
                                 default = newJBool(true))
  if valid_589128 != nil:
    section.add "prettyPrint", valid_589128
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589129: Call_GenomicsOperationsGet_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  let valid = call_589129.validator(path, query, header, formData, body)
  let scheme = call_589129.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589129.url(scheme.get, call_589129.host, call_589129.base,
                         call_589129.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589129, url, valid)

proc call*(call_589130: Call_GenomicsOperationsGet_589114; name: string;
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
  var path_589131 = newJObject()
  var query_589132 = newJObject()
  add(query_589132, "upload_protocol", newJString(uploadProtocol))
  add(query_589132, "fields", newJString(fields))
  add(query_589132, "quotaUser", newJString(quotaUser))
  add(path_589131, "name", newJString(name))
  add(query_589132, "alt", newJString(alt))
  add(query_589132, "oauth_token", newJString(oauthToken))
  add(query_589132, "callback", newJString(callback))
  add(query_589132, "access_token", newJString(accessToken))
  add(query_589132, "uploadType", newJString(uploadType))
  add(query_589132, "key", newJString(key))
  add(query_589132, "$.xgafv", newJString(Xgafv))
  add(query_589132, "prettyPrint", newJBool(prettyPrint))
  result = call_589130.call(path_589131, query_589132, nil, nil, nil)

var genomicsOperationsGet* = Call_GenomicsOperationsGet_589114(
    name: "genomicsOperationsGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}",
    validator: validate_GenomicsOperationsGet_589115, base: "/",
    url: url_GenomicsOperationsGet_589116, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsCancel_589133 = ref object of OpenApiRestCall_588441
proc url_GenomicsOperationsCancel_589135(protocol: Scheme; host: string;
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

proc validate_GenomicsOperationsCancel_589134(path: JsonNode; query: JsonNode;
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
  var valid_589136 = path.getOrDefault("name")
  valid_589136 = validateParameter(valid_589136, JString, required = true,
                                 default = nil)
  if valid_589136 != nil:
    section.add "name", valid_589136
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
  var valid_589137 = query.getOrDefault("upload_protocol")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "upload_protocol", valid_589137
  var valid_589138 = query.getOrDefault("fields")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "fields", valid_589138
  var valid_589139 = query.getOrDefault("quotaUser")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = nil)
  if valid_589139 != nil:
    section.add "quotaUser", valid_589139
  var valid_589140 = query.getOrDefault("alt")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = newJString("json"))
  if valid_589140 != nil:
    section.add "alt", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("callback")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "callback", valid_589142
  var valid_589143 = query.getOrDefault("access_token")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "access_token", valid_589143
  var valid_589144 = query.getOrDefault("uploadType")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "uploadType", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("$.xgafv")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("1"))
  if valid_589146 != nil:
    section.add "$.xgafv", valid_589146
  var valid_589147 = query.getOrDefault("prettyPrint")
  valid_589147 = validateParameter(valid_589147, JBool, required = false,
                                 default = newJBool(true))
  if valid_589147 != nil:
    section.add "prettyPrint", valid_589147
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

proc call*(call_589149: Call_GenomicsOperationsCancel_589133; path: JsonNode;
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
  let valid = call_589149.validator(path, query, header, formData, body)
  let scheme = call_589149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589149.url(scheme.get, call_589149.host, call_589149.base,
                         call_589149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589149, url, valid)

proc call*(call_589150: Call_GenomicsOperationsCancel_589133; name: string;
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
  var path_589151 = newJObject()
  var query_589152 = newJObject()
  var body_589153 = newJObject()
  add(query_589152, "upload_protocol", newJString(uploadProtocol))
  add(query_589152, "fields", newJString(fields))
  add(query_589152, "quotaUser", newJString(quotaUser))
  add(path_589151, "name", newJString(name))
  add(query_589152, "alt", newJString(alt))
  add(query_589152, "oauth_token", newJString(oauthToken))
  add(query_589152, "callback", newJString(callback))
  add(query_589152, "access_token", newJString(accessToken))
  add(query_589152, "uploadType", newJString(uploadType))
  add(query_589152, "key", newJString(key))
  add(query_589152, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_589153 = body
  add(query_589152, "prettyPrint", newJBool(prettyPrint))
  result = call_589150.call(path_589151, query_589152, nil, nil, body_589153)

var genomicsOperationsCancel* = Call_GenomicsOperationsCancel_589133(
    name: "genomicsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}:cancel",
    validator: validate_GenomicsOperationsCancel_589134, base: "/",
    url: url_GenomicsOperationsCancel_589135, schemes: {Scheme.Https})
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
