
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_GenomicsPipelinesCreate_593953 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesCreate_593955(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesCreate_593954(path: JsonNode; query: JsonNode;
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
  var valid_593956 = query.getOrDefault("upload_protocol")
  valid_593956 = validateParameter(valid_593956, JString, required = false,
                                 default = nil)
  if valid_593956 != nil:
    section.add "upload_protocol", valid_593956
  var valid_593957 = query.getOrDefault("fields")
  valid_593957 = validateParameter(valid_593957, JString, required = false,
                                 default = nil)
  if valid_593957 != nil:
    section.add "fields", valid_593957
  var valid_593958 = query.getOrDefault("quotaUser")
  valid_593958 = validateParameter(valid_593958, JString, required = false,
                                 default = nil)
  if valid_593958 != nil:
    section.add "quotaUser", valid_593958
  var valid_593959 = query.getOrDefault("alt")
  valid_593959 = validateParameter(valid_593959, JString, required = false,
                                 default = newJString("json"))
  if valid_593959 != nil:
    section.add "alt", valid_593959
  var valid_593960 = query.getOrDefault("oauth_token")
  valid_593960 = validateParameter(valid_593960, JString, required = false,
                                 default = nil)
  if valid_593960 != nil:
    section.add "oauth_token", valid_593960
  var valid_593961 = query.getOrDefault("callback")
  valid_593961 = validateParameter(valid_593961, JString, required = false,
                                 default = nil)
  if valid_593961 != nil:
    section.add "callback", valid_593961
  var valid_593962 = query.getOrDefault("access_token")
  valid_593962 = validateParameter(valid_593962, JString, required = false,
                                 default = nil)
  if valid_593962 != nil:
    section.add "access_token", valid_593962
  var valid_593963 = query.getOrDefault("uploadType")
  valid_593963 = validateParameter(valid_593963, JString, required = false,
                                 default = nil)
  if valid_593963 != nil:
    section.add "uploadType", valid_593963
  var valid_593964 = query.getOrDefault("key")
  valid_593964 = validateParameter(valid_593964, JString, required = false,
                                 default = nil)
  if valid_593964 != nil:
    section.add "key", valid_593964
  var valid_593965 = query.getOrDefault("$.xgafv")
  valid_593965 = validateParameter(valid_593965, JString, required = false,
                                 default = newJString("1"))
  if valid_593965 != nil:
    section.add "$.xgafv", valid_593965
  var valid_593966 = query.getOrDefault("prettyPrint")
  valid_593966 = validateParameter(valid_593966, JBool, required = false,
                                 default = newJBool(true))
  if valid_593966 != nil:
    section.add "prettyPrint", valid_593966
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

proc call*(call_593968: Call_GenomicsPipelinesCreate_593953; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a pipeline that can be run later. Create takes a Pipeline that
  ## has all fields other than `pipelineId` populated, and then returns
  ## the same pipeline with `pipelineId` populated. This id can be used
  ## to run the pipeline.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_593968.validator(path, query, header, formData, body)
  let scheme = call_593968.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593968.url(scheme.get, call_593968.host, call_593968.base,
                         call_593968.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593968, url, valid)

proc call*(call_593969: Call_GenomicsPipelinesCreate_593953;
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
  var query_593970 = newJObject()
  var body_593971 = newJObject()
  add(query_593970, "upload_protocol", newJString(uploadProtocol))
  add(query_593970, "fields", newJString(fields))
  add(query_593970, "quotaUser", newJString(quotaUser))
  add(query_593970, "alt", newJString(alt))
  add(query_593970, "oauth_token", newJString(oauthToken))
  add(query_593970, "callback", newJString(callback))
  add(query_593970, "access_token", newJString(accessToken))
  add(query_593970, "uploadType", newJString(uploadType))
  add(query_593970, "key", newJString(key))
  add(query_593970, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_593971 = body
  add(query_593970, "prettyPrint", newJBool(prettyPrint))
  result = call_593969.call(nil, query_593970, nil, nil, body_593971)

var genomicsPipelinesCreate* = Call_GenomicsPipelinesCreate_593953(
    name: "genomicsPipelinesCreate", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesCreate_593954, base: "/",
    url: url_GenomicsPipelinesCreate_593955, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesList_593677 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesList_593679(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesList_593678(path: JsonNode; query: JsonNode;
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
  var valid_593791 = query.getOrDefault("upload_protocol")
  valid_593791 = validateParameter(valid_593791, JString, required = false,
                                 default = nil)
  if valid_593791 != nil:
    section.add "upload_protocol", valid_593791
  var valid_593792 = query.getOrDefault("fields")
  valid_593792 = validateParameter(valid_593792, JString, required = false,
                                 default = nil)
  if valid_593792 != nil:
    section.add "fields", valid_593792
  var valid_593793 = query.getOrDefault("pageToken")
  valid_593793 = validateParameter(valid_593793, JString, required = false,
                                 default = nil)
  if valid_593793 != nil:
    section.add "pageToken", valid_593793
  var valid_593794 = query.getOrDefault("quotaUser")
  valid_593794 = validateParameter(valid_593794, JString, required = false,
                                 default = nil)
  if valid_593794 != nil:
    section.add "quotaUser", valid_593794
  var valid_593808 = query.getOrDefault("alt")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = newJString("json"))
  if valid_593808 != nil:
    section.add "alt", valid_593808
  var valid_593809 = query.getOrDefault("namePrefix")
  valid_593809 = validateParameter(valid_593809, JString, required = false,
                                 default = nil)
  if valid_593809 != nil:
    section.add "namePrefix", valid_593809
  var valid_593810 = query.getOrDefault("oauth_token")
  valid_593810 = validateParameter(valid_593810, JString, required = false,
                                 default = nil)
  if valid_593810 != nil:
    section.add "oauth_token", valid_593810
  var valid_593811 = query.getOrDefault("callback")
  valid_593811 = validateParameter(valid_593811, JString, required = false,
                                 default = nil)
  if valid_593811 != nil:
    section.add "callback", valid_593811
  var valid_593812 = query.getOrDefault("access_token")
  valid_593812 = validateParameter(valid_593812, JString, required = false,
                                 default = nil)
  if valid_593812 != nil:
    section.add "access_token", valid_593812
  var valid_593813 = query.getOrDefault("uploadType")
  valid_593813 = validateParameter(valid_593813, JString, required = false,
                                 default = nil)
  if valid_593813 != nil:
    section.add "uploadType", valid_593813
  var valid_593814 = query.getOrDefault("key")
  valid_593814 = validateParameter(valid_593814, JString, required = false,
                                 default = nil)
  if valid_593814 != nil:
    section.add "key", valid_593814
  var valid_593815 = query.getOrDefault("$.xgafv")
  valid_593815 = validateParameter(valid_593815, JString, required = false,
                                 default = newJString("1"))
  if valid_593815 != nil:
    section.add "$.xgafv", valid_593815
  var valid_593816 = query.getOrDefault("pageSize")
  valid_593816 = validateParameter(valid_593816, JInt, required = false, default = nil)
  if valid_593816 != nil:
    section.add "pageSize", valid_593816
  var valid_593817 = query.getOrDefault("projectId")
  valid_593817 = validateParameter(valid_593817, JString, required = false,
                                 default = nil)
  if valid_593817 != nil:
    section.add "projectId", valid_593817
  var valid_593818 = query.getOrDefault("prettyPrint")
  valid_593818 = validateParameter(valid_593818, JBool, required = false,
                                 default = newJBool(true))
  if valid_593818 != nil:
    section.add "prettyPrint", valid_593818
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593841: Call_GenomicsPipelinesList_593677; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists pipelines.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_593841.validator(path, query, header, formData, body)
  let scheme = call_593841.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593841.url(scheme.get, call_593841.host, call_593841.base,
                         call_593841.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593841, url, valid)

proc call*(call_593912: Call_GenomicsPipelinesList_593677;
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
  var query_593913 = newJObject()
  add(query_593913, "upload_protocol", newJString(uploadProtocol))
  add(query_593913, "fields", newJString(fields))
  add(query_593913, "pageToken", newJString(pageToken))
  add(query_593913, "quotaUser", newJString(quotaUser))
  add(query_593913, "alt", newJString(alt))
  add(query_593913, "namePrefix", newJString(namePrefix))
  add(query_593913, "oauth_token", newJString(oauthToken))
  add(query_593913, "callback", newJString(callback))
  add(query_593913, "access_token", newJString(accessToken))
  add(query_593913, "uploadType", newJString(uploadType))
  add(query_593913, "key", newJString(key))
  add(query_593913, "$.xgafv", newJString(Xgafv))
  add(query_593913, "pageSize", newJInt(pageSize))
  add(query_593913, "projectId", newJString(projectId))
  add(query_593913, "prettyPrint", newJBool(prettyPrint))
  result = call_593912.call(nil, query_593913, nil, nil, nil)

var genomicsPipelinesList* = Call_GenomicsPipelinesList_593677(
    name: "genomicsPipelinesList", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines",
    validator: validate_GenomicsPipelinesList_593678, base: "/",
    url: url_GenomicsPipelinesList_593679, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGet_593972 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesGet_593974(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesGet_593973(path: JsonNode; query: JsonNode;
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
  var valid_593989 = path.getOrDefault("pipelineId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "pipelineId", valid_593989
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
  var valid_593990 = query.getOrDefault("upload_protocol")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "upload_protocol", valid_593990
  var valid_593991 = query.getOrDefault("fields")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = nil)
  if valid_593991 != nil:
    section.add "fields", valid_593991
  var valid_593992 = query.getOrDefault("quotaUser")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "quotaUser", valid_593992
  var valid_593993 = query.getOrDefault("alt")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = newJString("json"))
  if valid_593993 != nil:
    section.add "alt", valid_593993
  var valid_593994 = query.getOrDefault("oauth_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "oauth_token", valid_593994
  var valid_593995 = query.getOrDefault("callback")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "callback", valid_593995
  var valid_593996 = query.getOrDefault("access_token")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "access_token", valid_593996
  var valid_593997 = query.getOrDefault("uploadType")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "uploadType", valid_593997
  var valid_593998 = query.getOrDefault("key")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "key", valid_593998
  var valid_593999 = query.getOrDefault("$.xgafv")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("1"))
  if valid_593999 != nil:
    section.add "$.xgafv", valid_593999
  var valid_594000 = query.getOrDefault("prettyPrint")
  valid_594000 = validateParameter(valid_594000, JBool, required = false,
                                 default = newJBool(true))
  if valid_594000 != nil:
    section.add "prettyPrint", valid_594000
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594001: Call_GenomicsPipelinesGet_593972; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a pipeline based on ID.
  ## 
  ## Caller must have READ permission to the project.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_GenomicsPipelinesGet_593972; pipelineId: string;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(path_594003, "pipelineId", newJString(pipelineId))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  result = call_594002.call(path_594003, query_594004, nil, nil, nil)

var genomicsPipelinesGet* = Call_GenomicsPipelinesGet_593972(
    name: "genomicsPipelinesGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesGet_593973, base: "/",
    url: url_GenomicsPipelinesGet_593974, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesDelete_594005 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesDelete_594007(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "pipelineId" in path, "`pipelineId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/pipelines/"),
               (kind: VariableSegment, value: "pipelineId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsPipelinesDelete_594006(path: JsonNode; query: JsonNode;
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
  var valid_594008 = path.getOrDefault("pipelineId")
  valid_594008 = validateParameter(valid_594008, JString, required = true,
                                 default = nil)
  if valid_594008 != nil:
    section.add "pipelineId", valid_594008
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
  var valid_594009 = query.getOrDefault("upload_protocol")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "upload_protocol", valid_594009
  var valid_594010 = query.getOrDefault("fields")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "fields", valid_594010
  var valid_594011 = query.getOrDefault("quotaUser")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "quotaUser", valid_594011
  var valid_594012 = query.getOrDefault("alt")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = newJString("json"))
  if valid_594012 != nil:
    section.add "alt", valid_594012
  var valid_594013 = query.getOrDefault("oauth_token")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "oauth_token", valid_594013
  var valid_594014 = query.getOrDefault("callback")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = nil)
  if valid_594014 != nil:
    section.add "callback", valid_594014
  var valid_594015 = query.getOrDefault("access_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "access_token", valid_594015
  var valid_594016 = query.getOrDefault("uploadType")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "uploadType", valid_594016
  var valid_594017 = query.getOrDefault("key")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "key", valid_594017
  var valid_594018 = query.getOrDefault("$.xgafv")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = newJString("1"))
  if valid_594018 != nil:
    section.add "$.xgafv", valid_594018
  var valid_594019 = query.getOrDefault("prettyPrint")
  valid_594019 = validateParameter(valid_594019, JBool, required = false,
                                 default = newJBool(true))
  if valid_594019 != nil:
    section.add "prettyPrint", valid_594019
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594020: Call_GenomicsPipelinesDelete_594005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a pipeline based on ID.
  ## 
  ## Caller must have WRITE permission to the project.
  ## 
  let valid = call_594020.validator(path, query, header, formData, body)
  let scheme = call_594020.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594020.url(scheme.get, call_594020.host, call_594020.base,
                         call_594020.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594020, url, valid)

proc call*(call_594021: Call_GenomicsPipelinesDelete_594005; pipelineId: string;
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
  var path_594022 = newJObject()
  var query_594023 = newJObject()
  add(query_594023, "upload_protocol", newJString(uploadProtocol))
  add(query_594023, "fields", newJString(fields))
  add(query_594023, "quotaUser", newJString(quotaUser))
  add(query_594023, "alt", newJString(alt))
  add(query_594023, "oauth_token", newJString(oauthToken))
  add(query_594023, "callback", newJString(callback))
  add(query_594023, "access_token", newJString(accessToken))
  add(query_594023, "uploadType", newJString(uploadType))
  add(path_594022, "pipelineId", newJString(pipelineId))
  add(query_594023, "key", newJString(key))
  add(query_594023, "$.xgafv", newJString(Xgafv))
  add(query_594023, "prettyPrint", newJBool(prettyPrint))
  result = call_594021.call(path_594022, query_594023, nil, nil, nil)

var genomicsPipelinesDelete* = Call_GenomicsPipelinesDelete_594005(
    name: "genomicsPipelinesDelete", meth: HttpMethod.HttpDelete,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines/{pipelineId}",
    validator: validate_GenomicsPipelinesDelete_594006, base: "/",
    url: url_GenomicsPipelinesDelete_594007, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesGetControllerConfig_594024 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesGetControllerConfig_594026(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesGetControllerConfig_594025(path: JsonNode;
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
  var valid_594027 = query.getOrDefault("upload_protocol")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "upload_protocol", valid_594027
  var valid_594028 = query.getOrDefault("fields")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "fields", valid_594028
  var valid_594029 = query.getOrDefault("quotaUser")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "quotaUser", valid_594029
  var valid_594030 = query.getOrDefault("validationToken")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "validationToken", valid_594030
  var valid_594031 = query.getOrDefault("alt")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = newJString("json"))
  if valid_594031 != nil:
    section.add "alt", valid_594031
  var valid_594032 = query.getOrDefault("operationId")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "operationId", valid_594032
  var valid_594033 = query.getOrDefault("oauth_token")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "oauth_token", valid_594033
  var valid_594034 = query.getOrDefault("callback")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "callback", valid_594034
  var valid_594035 = query.getOrDefault("access_token")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "access_token", valid_594035
  var valid_594036 = query.getOrDefault("uploadType")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "uploadType", valid_594036
  var valid_594037 = query.getOrDefault("key")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "key", valid_594037
  var valid_594038 = query.getOrDefault("$.xgafv")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("1"))
  if valid_594038 != nil:
    section.add "$.xgafv", valid_594038
  var valid_594039 = query.getOrDefault("prettyPrint")
  valid_594039 = validateParameter(valid_594039, JBool, required = false,
                                 default = newJBool(true))
  if valid_594039 != nil:
    section.add "prettyPrint", valid_594039
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594040: Call_GenomicsPipelinesGetControllerConfig_594024;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets controller configuration information. Should only be called
  ## by VMs created by the Pipelines Service and not by end users.
  ## 
  let valid = call_594040.validator(path, query, header, formData, body)
  let scheme = call_594040.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594040.url(scheme.get, call_594040.host, call_594040.base,
                         call_594040.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594040, url, valid)

proc call*(call_594041: Call_GenomicsPipelinesGetControllerConfig_594024;
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
  var query_594042 = newJObject()
  add(query_594042, "upload_protocol", newJString(uploadProtocol))
  add(query_594042, "fields", newJString(fields))
  add(query_594042, "quotaUser", newJString(quotaUser))
  add(query_594042, "validationToken", newJString(validationToken))
  add(query_594042, "alt", newJString(alt))
  add(query_594042, "operationId", newJString(operationId))
  add(query_594042, "oauth_token", newJString(oauthToken))
  add(query_594042, "callback", newJString(callback))
  add(query_594042, "access_token", newJString(accessToken))
  add(query_594042, "uploadType", newJString(uploadType))
  add(query_594042, "key", newJString(key))
  add(query_594042, "$.xgafv", newJString(Xgafv))
  add(query_594042, "prettyPrint", newJBool(prettyPrint))
  result = call_594041.call(nil, query_594042, nil, nil, nil)

var genomicsPipelinesGetControllerConfig* = Call_GenomicsPipelinesGetControllerConfig_594024(
    name: "genomicsPipelinesGetControllerConfig", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:getControllerConfig",
    validator: validate_GenomicsPipelinesGetControllerConfig_594025, base: "/",
    url: url_GenomicsPipelinesGetControllerConfig_594026, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesRun_594043 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesRun_594045(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesRun_594044(path: JsonNode; query: JsonNode;
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
  var valid_594046 = query.getOrDefault("upload_protocol")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "upload_protocol", valid_594046
  var valid_594047 = query.getOrDefault("fields")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "fields", valid_594047
  var valid_594048 = query.getOrDefault("quotaUser")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "quotaUser", valid_594048
  var valid_594049 = query.getOrDefault("alt")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = newJString("json"))
  if valid_594049 != nil:
    section.add "alt", valid_594049
  var valid_594050 = query.getOrDefault("oauth_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "oauth_token", valid_594050
  var valid_594051 = query.getOrDefault("callback")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "callback", valid_594051
  var valid_594052 = query.getOrDefault("access_token")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "access_token", valid_594052
  var valid_594053 = query.getOrDefault("uploadType")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = nil)
  if valid_594053 != nil:
    section.add "uploadType", valid_594053
  var valid_594054 = query.getOrDefault("key")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "key", valid_594054
  var valid_594055 = query.getOrDefault("$.xgafv")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = newJString("1"))
  if valid_594055 != nil:
    section.add "$.xgafv", valid_594055
  var valid_594056 = query.getOrDefault("prettyPrint")
  valid_594056 = validateParameter(valid_594056, JBool, required = false,
                                 default = newJBool(true))
  if valid_594056 != nil:
    section.add "prettyPrint", valid_594056
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

proc call*(call_594058: Call_GenomicsPipelinesRun_594043; path: JsonNode;
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
  let valid = call_594058.validator(path, query, header, formData, body)
  let scheme = call_594058.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594058.url(scheme.get, call_594058.host, call_594058.base,
                         call_594058.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594058, url, valid)

proc call*(call_594059: Call_GenomicsPipelinesRun_594043;
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
  var query_594060 = newJObject()
  var body_594061 = newJObject()
  add(query_594060, "upload_protocol", newJString(uploadProtocol))
  add(query_594060, "fields", newJString(fields))
  add(query_594060, "quotaUser", newJString(quotaUser))
  add(query_594060, "alt", newJString(alt))
  add(query_594060, "oauth_token", newJString(oauthToken))
  add(query_594060, "callback", newJString(callback))
  add(query_594060, "access_token", newJString(accessToken))
  add(query_594060, "uploadType", newJString(uploadType))
  add(query_594060, "key", newJString(key))
  add(query_594060, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594061 = body
  add(query_594060, "prettyPrint", newJBool(prettyPrint))
  result = call_594059.call(nil, query_594060, nil, nil, body_594061)

var genomicsPipelinesRun* = Call_GenomicsPipelinesRun_594043(
    name: "genomicsPipelinesRun", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/pipelines:run",
    validator: validate_GenomicsPipelinesRun_594044, base: "/",
    url: url_GenomicsPipelinesRun_594045, schemes: {Scheme.Https})
type
  Call_GenomicsPipelinesSetOperationStatus_594062 = ref object of OpenApiRestCall_593408
proc url_GenomicsPipelinesSetOperationStatus_594064(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_GenomicsPipelinesSetOperationStatus_594063(path: JsonNode;
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
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("callback")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "callback", valid_594070
  var valid_594071 = query.getOrDefault("access_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "access_token", valid_594071
  var valid_594072 = query.getOrDefault("uploadType")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "uploadType", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("$.xgafv")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("1"))
  if valid_594074 != nil:
    section.add "$.xgafv", valid_594074
  var valid_594075 = query.getOrDefault("prettyPrint")
  valid_594075 = validateParameter(valid_594075, JBool, required = false,
                                 default = newJBool(true))
  if valid_594075 != nil:
    section.add "prettyPrint", valid_594075
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

proc call*(call_594077: Call_GenomicsPipelinesSetOperationStatus_594062;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets status of a given operation. Any new timestamps (as determined by
  ## description) are appended to TimestampEvents. Should only be called by VMs
  ## created by the Pipelines Service and not by end users.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_GenomicsPipelinesSetOperationStatus_594062;
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
  var query_594079 = newJObject()
  var body_594080 = newJObject()
  add(query_594079, "upload_protocol", newJString(uploadProtocol))
  add(query_594079, "fields", newJString(fields))
  add(query_594079, "quotaUser", newJString(quotaUser))
  add(query_594079, "alt", newJString(alt))
  add(query_594079, "oauth_token", newJString(oauthToken))
  add(query_594079, "callback", newJString(callback))
  add(query_594079, "access_token", newJString(accessToken))
  add(query_594079, "uploadType", newJString(uploadType))
  add(query_594079, "key", newJString(key))
  add(query_594079, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594080 = body
  add(query_594079, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(nil, query_594079, nil, nil, body_594080)

var genomicsPipelinesSetOperationStatus* = Call_GenomicsPipelinesSetOperationStatus_594062(
    name: "genomicsPipelinesSetOperationStatus", meth: HttpMethod.HttpPut,
    host: "genomics.googleapis.com",
    route: "/v1alpha2/pipelines:setOperationStatus",
    validator: validate_GenomicsPipelinesSetOperationStatus_594063, base: "/",
    url: url_GenomicsPipelinesSetOperationStatus_594064, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsGet_594081 = ref object of OpenApiRestCall_593408
proc url_GenomicsOperationsGet_594083(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1alpha2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_GenomicsOperationsGet_594082(path: JsonNode; query: JsonNode;
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
  var valid_594084 = path.getOrDefault("name")
  valid_594084 = validateParameter(valid_594084, JString, required = true,
                                 default = nil)
  if valid_594084 != nil:
    section.add "name", valid_594084
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
  var valid_594085 = query.getOrDefault("upload_protocol")
  valid_594085 = validateParameter(valid_594085, JString, required = false,
                                 default = nil)
  if valid_594085 != nil:
    section.add "upload_protocol", valid_594085
  var valid_594086 = query.getOrDefault("fields")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "fields", valid_594086
  var valid_594087 = query.getOrDefault("quotaUser")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "quotaUser", valid_594087
  var valid_594088 = query.getOrDefault("alt")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = newJString("json"))
  if valid_594088 != nil:
    section.add "alt", valid_594088
  var valid_594089 = query.getOrDefault("oauth_token")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "oauth_token", valid_594089
  var valid_594090 = query.getOrDefault("callback")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "callback", valid_594090
  var valid_594091 = query.getOrDefault("access_token")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "access_token", valid_594091
  var valid_594092 = query.getOrDefault("uploadType")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "uploadType", valid_594092
  var valid_594093 = query.getOrDefault("key")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "key", valid_594093
  var valid_594094 = query.getOrDefault("$.xgafv")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("1"))
  if valid_594094 != nil:
    section.add "$.xgafv", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594096: Call_GenomicsOperationsGet_594081; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.
  ## Clients can use this method to poll the operation result at intervals as
  ## recommended by the API service.
  ## Authorization requires the following [Google IAM](https://cloud.google.com/iam) permission&#58;
  ## 
  ## * `genomics.operations.get`
  ## 
  let valid = call_594096.validator(path, query, header, formData, body)
  let scheme = call_594096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594096.url(scheme.get, call_594096.host, call_594096.base,
                         call_594096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594096, url, valid)

proc call*(call_594097: Call_GenomicsOperationsGet_594081; name: string;
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
  var path_594098 = newJObject()
  var query_594099 = newJObject()
  add(query_594099, "upload_protocol", newJString(uploadProtocol))
  add(query_594099, "fields", newJString(fields))
  add(query_594099, "quotaUser", newJString(quotaUser))
  add(path_594098, "name", newJString(name))
  add(query_594099, "alt", newJString(alt))
  add(query_594099, "oauth_token", newJString(oauthToken))
  add(query_594099, "callback", newJString(callback))
  add(query_594099, "access_token", newJString(accessToken))
  add(query_594099, "uploadType", newJString(uploadType))
  add(query_594099, "key", newJString(key))
  add(query_594099, "$.xgafv", newJString(Xgafv))
  add(query_594099, "prettyPrint", newJBool(prettyPrint))
  result = call_594097.call(path_594098, query_594099, nil, nil, nil)

var genomicsOperationsGet* = Call_GenomicsOperationsGet_594081(
    name: "genomicsOperationsGet", meth: HttpMethod.HttpGet,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}",
    validator: validate_GenomicsOperationsGet_594082, base: "/",
    url: url_GenomicsOperationsGet_594083, schemes: {Scheme.Https})
type
  Call_GenomicsOperationsCancel_594100 = ref object of OpenApiRestCall_593408
proc url_GenomicsOperationsCancel_594102(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_GenomicsOperationsCancel_594101(path: JsonNode; query: JsonNode;
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
  var valid_594103 = path.getOrDefault("name")
  valid_594103 = validateParameter(valid_594103, JString, required = true,
                                 default = nil)
  if valid_594103 != nil:
    section.add "name", valid_594103
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
  var valid_594104 = query.getOrDefault("upload_protocol")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "upload_protocol", valid_594104
  var valid_594105 = query.getOrDefault("fields")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "fields", valid_594105
  var valid_594106 = query.getOrDefault("quotaUser")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "quotaUser", valid_594106
  var valid_594107 = query.getOrDefault("alt")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = newJString("json"))
  if valid_594107 != nil:
    section.add "alt", valid_594107
  var valid_594108 = query.getOrDefault("oauth_token")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "oauth_token", valid_594108
  var valid_594109 = query.getOrDefault("callback")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "callback", valid_594109
  var valid_594110 = query.getOrDefault("access_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "access_token", valid_594110
  var valid_594111 = query.getOrDefault("uploadType")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "uploadType", valid_594111
  var valid_594112 = query.getOrDefault("key")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "key", valid_594112
  var valid_594113 = query.getOrDefault("$.xgafv")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("1"))
  if valid_594113 != nil:
    section.add "$.xgafv", valid_594113
  var valid_594114 = query.getOrDefault("prettyPrint")
  valid_594114 = validateParameter(valid_594114, JBool, required = false,
                                 default = newJBool(true))
  if valid_594114 != nil:
    section.add "prettyPrint", valid_594114
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

proc call*(call_594116: Call_GenomicsOperationsCancel_594100; path: JsonNode;
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
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_GenomicsOperationsCancel_594100; name: string;
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
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  var body_594120 = newJObject()
  add(query_594119, "upload_protocol", newJString(uploadProtocol))
  add(query_594119, "fields", newJString(fields))
  add(query_594119, "quotaUser", newJString(quotaUser))
  add(path_594118, "name", newJString(name))
  add(query_594119, "alt", newJString(alt))
  add(query_594119, "oauth_token", newJString(oauthToken))
  add(query_594119, "callback", newJString(callback))
  add(query_594119, "access_token", newJString(accessToken))
  add(query_594119, "uploadType", newJString(uploadType))
  add(query_594119, "key", newJString(key))
  add(query_594119, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594120 = body
  add(query_594119, "prettyPrint", newJBool(prettyPrint))
  result = call_594117.call(path_594118, query_594119, nil, nil, body_594120)

var genomicsOperationsCancel* = Call_GenomicsOperationsCancel_594100(
    name: "genomicsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "genomics.googleapis.com", route: "/v1alpha2/{name}:cancel",
    validator: validate_GenomicsOperationsCancel_594101, base: "/",
    url: url_GenomicsOperationsCancel_594102, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
