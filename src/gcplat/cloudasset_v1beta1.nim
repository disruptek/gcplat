
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Asset
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## The cloud asset API manages the history and inventory of cloud resources.
## 
## https://cloud.google.com/resource-manager/docs/cloud-asset-inventory/quickstart-cloud-asset-inventory
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

  OpenApiRestCall_597408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_597408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_597408): Option[Scheme] {.used.} =
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
  gcpServiceName = "cloudasset"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudassetProjectsOperationsGet_597677 = ref object of OpenApiRestCall_597408
proc url_CloudassetProjectsOperationsGet_597679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudassetProjectsOperationsGet_597678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_597805 = path.getOrDefault("name")
  valid_597805 = validateParameter(valid_597805, JString, required = true,
                                 default = nil)
  if valid_597805 != nil:
    section.add "name", valid_597805
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
  var valid_597806 = query.getOrDefault("upload_protocol")
  valid_597806 = validateParameter(valid_597806, JString, required = false,
                                 default = nil)
  if valid_597806 != nil:
    section.add "upload_protocol", valid_597806
  var valid_597807 = query.getOrDefault("fields")
  valid_597807 = validateParameter(valid_597807, JString, required = false,
                                 default = nil)
  if valid_597807 != nil:
    section.add "fields", valid_597807
  var valid_597808 = query.getOrDefault("quotaUser")
  valid_597808 = validateParameter(valid_597808, JString, required = false,
                                 default = nil)
  if valid_597808 != nil:
    section.add "quotaUser", valid_597808
  var valid_597822 = query.getOrDefault("alt")
  valid_597822 = validateParameter(valid_597822, JString, required = false,
                                 default = newJString("json"))
  if valid_597822 != nil:
    section.add "alt", valid_597822
  var valid_597823 = query.getOrDefault("oauth_token")
  valid_597823 = validateParameter(valid_597823, JString, required = false,
                                 default = nil)
  if valid_597823 != nil:
    section.add "oauth_token", valid_597823
  var valid_597824 = query.getOrDefault("callback")
  valid_597824 = validateParameter(valid_597824, JString, required = false,
                                 default = nil)
  if valid_597824 != nil:
    section.add "callback", valid_597824
  var valid_597825 = query.getOrDefault("access_token")
  valid_597825 = validateParameter(valid_597825, JString, required = false,
                                 default = nil)
  if valid_597825 != nil:
    section.add "access_token", valid_597825
  var valid_597826 = query.getOrDefault("uploadType")
  valid_597826 = validateParameter(valid_597826, JString, required = false,
                                 default = nil)
  if valid_597826 != nil:
    section.add "uploadType", valid_597826
  var valid_597827 = query.getOrDefault("key")
  valid_597827 = validateParameter(valid_597827, JString, required = false,
                                 default = nil)
  if valid_597827 != nil:
    section.add "key", valid_597827
  var valid_597828 = query.getOrDefault("$.xgafv")
  valid_597828 = validateParameter(valid_597828, JString, required = false,
                                 default = newJString("1"))
  if valid_597828 != nil:
    section.add "$.xgafv", valid_597828
  var valid_597829 = query.getOrDefault("prettyPrint")
  valid_597829 = validateParameter(valid_597829, JBool, required = false,
                                 default = newJBool(true))
  if valid_597829 != nil:
    section.add "prettyPrint", valid_597829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597852: Call_CloudassetProjectsOperationsGet_597677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_597852.validator(path, query, header, formData, body)
  let scheme = call_597852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597852.url(scheme.get, call_597852.host, call_597852.base,
                         call_597852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597852, url, valid)

proc call*(call_597923: Call_CloudassetProjectsOperationsGet_597677; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## cloudassetProjectsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  var path_597924 = newJObject()
  var query_597926 = newJObject()
  add(query_597926, "upload_protocol", newJString(uploadProtocol))
  add(query_597926, "fields", newJString(fields))
  add(query_597926, "quotaUser", newJString(quotaUser))
  add(path_597924, "name", newJString(name))
  add(query_597926, "alt", newJString(alt))
  add(query_597926, "oauth_token", newJString(oauthToken))
  add(query_597926, "callback", newJString(callback))
  add(query_597926, "access_token", newJString(accessToken))
  add(query_597926, "uploadType", newJString(uploadType))
  add(query_597926, "key", newJString(key))
  add(query_597926, "$.xgafv", newJString(Xgafv))
  add(query_597926, "prettyPrint", newJBool(prettyPrint))
  result = call_597923.call(path_597924, query_597926, nil, nil, nil)

var cloudassetProjectsOperationsGet* = Call_CloudassetProjectsOperationsGet_597677(
    name: "cloudassetProjectsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudasset.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudassetProjectsOperationsGet_597678, base: "/",
    url: url_CloudassetProjectsOperationsGet_597679, schemes: {Scheme.Https})
type
  Call_CloudassetProjectsBatchGetAssetsHistory_597965 = ref object of OpenApiRestCall_597408
proc url_CloudassetProjectsBatchGetAssetsHistory_597967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":batchGetAssetsHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudassetProjectsBatchGetAssetsHistory_597966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Batch gets the update history of assets that overlap a time window.
  ## For RESOURCE content, this API outputs history with asset in both
  ## non-delete or deleted status.
  ## For IAM_POLICY content, this API outputs history when the asset and its
  ## attached IAM POLICY both exist. This can create gaps in the output history.
  ## If a specified asset does not exist, this API returns an INVALID_ARGUMENT
  ## error.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The relative name of the root asset. It can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id")", or a project number (such as "projects/12345").
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_597968 = path.getOrDefault("parent")
  valid_597968 = validateParameter(valid_597968, JString, required = true,
                                 default = nil)
  if valid_597968 != nil:
    section.add "parent", valid_597968
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   readTimeWindow.endTime: JString
  ##                         : End time of the time window (inclusive).
  ## Current timestamp if not specified.
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
  ##   readTimeWindow.startTime: JString
  ##                           : Start time of the time window (exclusive).
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   contentType: JString
  ##              : Required. The content type.
  ##   assetNames: JArray
  ##             : A list of the full names of the assets. For example:
  ## 
  ## `//compute.googleapis.com/projects/my_project_123/zones/zone1/instances/instance1`.
  ## See [Resource
  ## Names](https://cloud.google.com/apis/design/resource_names#full_resource_name)
  ## for more info.
  ## 
  ## The request becomes a no-op if the asset name list is empty, and the max
  ## size of the asset name list is 100 in one request.
  section = newJObject()
  var valid_597969 = query.getOrDefault("upload_protocol")
  valid_597969 = validateParameter(valid_597969, JString, required = false,
                                 default = nil)
  if valid_597969 != nil:
    section.add "upload_protocol", valid_597969
  var valid_597970 = query.getOrDefault("fields")
  valid_597970 = validateParameter(valid_597970, JString, required = false,
                                 default = nil)
  if valid_597970 != nil:
    section.add "fields", valid_597970
  var valid_597971 = query.getOrDefault("quotaUser")
  valid_597971 = validateParameter(valid_597971, JString, required = false,
                                 default = nil)
  if valid_597971 != nil:
    section.add "quotaUser", valid_597971
  var valid_597972 = query.getOrDefault("readTimeWindow.endTime")
  valid_597972 = validateParameter(valid_597972, JString, required = false,
                                 default = nil)
  if valid_597972 != nil:
    section.add "readTimeWindow.endTime", valid_597972
  var valid_597973 = query.getOrDefault("alt")
  valid_597973 = validateParameter(valid_597973, JString, required = false,
                                 default = newJString("json"))
  if valid_597973 != nil:
    section.add "alt", valid_597973
  var valid_597974 = query.getOrDefault("oauth_token")
  valid_597974 = validateParameter(valid_597974, JString, required = false,
                                 default = nil)
  if valid_597974 != nil:
    section.add "oauth_token", valid_597974
  var valid_597975 = query.getOrDefault("callback")
  valid_597975 = validateParameter(valid_597975, JString, required = false,
                                 default = nil)
  if valid_597975 != nil:
    section.add "callback", valid_597975
  var valid_597976 = query.getOrDefault("access_token")
  valid_597976 = validateParameter(valid_597976, JString, required = false,
                                 default = nil)
  if valid_597976 != nil:
    section.add "access_token", valid_597976
  var valid_597977 = query.getOrDefault("uploadType")
  valid_597977 = validateParameter(valid_597977, JString, required = false,
                                 default = nil)
  if valid_597977 != nil:
    section.add "uploadType", valid_597977
  var valid_597978 = query.getOrDefault("readTimeWindow.startTime")
  valid_597978 = validateParameter(valid_597978, JString, required = false,
                                 default = nil)
  if valid_597978 != nil:
    section.add "readTimeWindow.startTime", valid_597978
  var valid_597979 = query.getOrDefault("key")
  valid_597979 = validateParameter(valid_597979, JString, required = false,
                                 default = nil)
  if valid_597979 != nil:
    section.add "key", valid_597979
  var valid_597980 = query.getOrDefault("$.xgafv")
  valid_597980 = validateParameter(valid_597980, JString, required = false,
                                 default = newJString("1"))
  if valid_597980 != nil:
    section.add "$.xgafv", valid_597980
  var valid_597981 = query.getOrDefault("prettyPrint")
  valid_597981 = validateParameter(valid_597981, JBool, required = false,
                                 default = newJBool(true))
  if valid_597981 != nil:
    section.add "prettyPrint", valid_597981
  var valid_597982 = query.getOrDefault("contentType")
  valid_597982 = validateParameter(valid_597982, JString, required = false, default = newJString(
      "CONTENT_TYPE_UNSPECIFIED"))
  if valid_597982 != nil:
    section.add "contentType", valid_597982
  var valid_597983 = query.getOrDefault("assetNames")
  valid_597983 = validateParameter(valid_597983, JArray, required = false,
                                 default = nil)
  if valid_597983 != nil:
    section.add "assetNames", valid_597983
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_597984: Call_CloudassetProjectsBatchGetAssetsHistory_597965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Batch gets the update history of assets that overlap a time window.
  ## For RESOURCE content, this API outputs history with asset in both
  ## non-delete or deleted status.
  ## For IAM_POLICY content, this API outputs history when the asset and its
  ## attached IAM POLICY both exist. This can create gaps in the output history.
  ## If a specified asset does not exist, this API returns an INVALID_ARGUMENT
  ## error.
  ## 
  let valid = call_597984.validator(path, query, header, formData, body)
  let scheme = call_597984.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_597984.url(scheme.get, call_597984.host, call_597984.base,
                         call_597984.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_597984, url, valid)

proc call*(call_597985: Call_CloudassetProjectsBatchGetAssetsHistory_597965;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; readTimeWindowEndTime: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = "";
          readTimeWindowStartTime: string = ""; key: string = ""; Xgafv: string = "1";
          prettyPrint: bool = true;
          contentType: string = "CONTENT_TYPE_UNSPECIFIED";
          assetNames: JsonNode = nil): Recallable =
  ## cloudassetProjectsBatchGetAssetsHistory
  ## Batch gets the update history of assets that overlap a time window.
  ## For RESOURCE content, this API outputs history with asset in both
  ## non-delete or deleted status.
  ## For IAM_POLICY content, this API outputs history when the asset and its
  ## attached IAM POLICY both exist. This can create gaps in the output history.
  ## If a specified asset does not exist, this API returns an INVALID_ARGUMENT
  ## error.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   readTimeWindowEndTime: string
  ##                        : End time of the time window (inclusive).
  ## Current timestamp if not specified.
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
  ##   parent: string (required)
  ##         : Required. The relative name of the root asset. It can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id")", or a project number (such as "projects/12345").
  ##   readTimeWindowStartTime: string
  ##                          : Start time of the time window (exclusive).
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   contentType: string
  ##              : Required. The content type.
  ##   assetNames: JArray
  ##             : A list of the full names of the assets. For example:
  ## 
  ## `//compute.googleapis.com/projects/my_project_123/zones/zone1/instances/instance1`.
  ## See [Resource
  ## Names](https://cloud.google.com/apis/design/resource_names#full_resource_name)
  ## for more info.
  ## 
  ## The request becomes a no-op if the asset name list is empty, and the max
  ## size of the asset name list is 100 in one request.
  var path_597986 = newJObject()
  var query_597987 = newJObject()
  add(query_597987, "upload_protocol", newJString(uploadProtocol))
  add(query_597987, "fields", newJString(fields))
  add(query_597987, "quotaUser", newJString(quotaUser))
  add(query_597987, "readTimeWindow.endTime", newJString(readTimeWindowEndTime))
  add(query_597987, "alt", newJString(alt))
  add(query_597987, "oauth_token", newJString(oauthToken))
  add(query_597987, "callback", newJString(callback))
  add(query_597987, "access_token", newJString(accessToken))
  add(query_597987, "uploadType", newJString(uploadType))
  add(path_597986, "parent", newJString(parent))
  add(query_597987, "readTimeWindow.startTime",
      newJString(readTimeWindowStartTime))
  add(query_597987, "key", newJString(key))
  add(query_597987, "$.xgafv", newJString(Xgafv))
  add(query_597987, "prettyPrint", newJBool(prettyPrint))
  add(query_597987, "contentType", newJString(contentType))
  if assetNames != nil:
    query_597987.add "assetNames", assetNames
  result = call_597985.call(path_597986, query_597987, nil, nil, nil)

var cloudassetProjectsBatchGetAssetsHistory* = Call_CloudassetProjectsBatchGetAssetsHistory_597965(
    name: "cloudassetProjectsBatchGetAssetsHistory", meth: HttpMethod.HttpGet,
    host: "cloudasset.googleapis.com",
    route: "/v1beta1/{parent}:batchGetAssetsHistory",
    validator: validate_CloudassetProjectsBatchGetAssetsHistory_597966, base: "/",
    url: url_CloudassetProjectsBatchGetAssetsHistory_597967,
    schemes: {Scheme.Https})
type
  Call_CloudassetProjectsExportAssets_597988 = ref object of OpenApiRestCall_597408
proc url_CloudassetProjectsExportAssets_597990(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":exportAssets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_CloudassetProjectsExportAssets_597989(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Exports assets with time and resource types to a given Cloud Storage
  ## location. The output format is newline-delimited JSON.
  ## This API implements the google.longrunning.Operation API allowing you
  ## to keep track of the export.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The relative name of the root asset. This can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id"), a project number (such as "projects/12345"), or
  ## a folder number (such as "folders/123").
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_597991 = path.getOrDefault("parent")
  valid_597991 = validateParameter(valid_597991, JString, required = true,
                                 default = nil)
  if valid_597991 != nil:
    section.add "parent", valid_597991
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
  var valid_597992 = query.getOrDefault("upload_protocol")
  valid_597992 = validateParameter(valid_597992, JString, required = false,
                                 default = nil)
  if valid_597992 != nil:
    section.add "upload_protocol", valid_597992
  var valid_597993 = query.getOrDefault("fields")
  valid_597993 = validateParameter(valid_597993, JString, required = false,
                                 default = nil)
  if valid_597993 != nil:
    section.add "fields", valid_597993
  var valid_597994 = query.getOrDefault("quotaUser")
  valid_597994 = validateParameter(valid_597994, JString, required = false,
                                 default = nil)
  if valid_597994 != nil:
    section.add "quotaUser", valid_597994
  var valid_597995 = query.getOrDefault("alt")
  valid_597995 = validateParameter(valid_597995, JString, required = false,
                                 default = newJString("json"))
  if valid_597995 != nil:
    section.add "alt", valid_597995
  var valid_597996 = query.getOrDefault("oauth_token")
  valid_597996 = validateParameter(valid_597996, JString, required = false,
                                 default = nil)
  if valid_597996 != nil:
    section.add "oauth_token", valid_597996
  var valid_597997 = query.getOrDefault("callback")
  valid_597997 = validateParameter(valid_597997, JString, required = false,
                                 default = nil)
  if valid_597997 != nil:
    section.add "callback", valid_597997
  var valid_597998 = query.getOrDefault("access_token")
  valid_597998 = validateParameter(valid_597998, JString, required = false,
                                 default = nil)
  if valid_597998 != nil:
    section.add "access_token", valid_597998
  var valid_597999 = query.getOrDefault("uploadType")
  valid_597999 = validateParameter(valid_597999, JString, required = false,
                                 default = nil)
  if valid_597999 != nil:
    section.add "uploadType", valid_597999
  var valid_598000 = query.getOrDefault("key")
  valid_598000 = validateParameter(valid_598000, JString, required = false,
                                 default = nil)
  if valid_598000 != nil:
    section.add "key", valid_598000
  var valid_598001 = query.getOrDefault("$.xgafv")
  valid_598001 = validateParameter(valid_598001, JString, required = false,
                                 default = newJString("1"))
  if valid_598001 != nil:
    section.add "$.xgafv", valid_598001
  var valid_598002 = query.getOrDefault("prettyPrint")
  valid_598002 = validateParameter(valid_598002, JBool, required = false,
                                 default = newJBool(true))
  if valid_598002 != nil:
    section.add "prettyPrint", valid_598002
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

proc call*(call_598004: Call_CloudassetProjectsExportAssets_597988; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Exports assets with time and resource types to a given Cloud Storage
  ## location. The output format is newline-delimited JSON.
  ## This API implements the google.longrunning.Operation API allowing you
  ## to keep track of the export.
  ## 
  let valid = call_598004.validator(path, query, header, formData, body)
  let scheme = call_598004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_598004.url(scheme.get, call_598004.host, call_598004.base,
                         call_598004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_598004, url, valid)

proc call*(call_598005: Call_CloudassetProjectsExportAssets_597988; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## cloudassetProjectsExportAssets
  ## Exports assets with time and resource types to a given Cloud Storage
  ## location. The output format is newline-delimited JSON.
  ## This API implements the google.longrunning.Operation API allowing you
  ## to keep track of the export.
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
  ##   parent: string (required)
  ##         : Required. The relative name of the root asset. This can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id"), a project number (such as "projects/12345"), or
  ## a folder number (such as "folders/123").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_598006 = newJObject()
  var query_598007 = newJObject()
  var body_598008 = newJObject()
  add(query_598007, "upload_protocol", newJString(uploadProtocol))
  add(query_598007, "fields", newJString(fields))
  add(query_598007, "quotaUser", newJString(quotaUser))
  add(query_598007, "alt", newJString(alt))
  add(query_598007, "oauth_token", newJString(oauthToken))
  add(query_598007, "callback", newJString(callback))
  add(query_598007, "access_token", newJString(accessToken))
  add(query_598007, "uploadType", newJString(uploadType))
  add(path_598006, "parent", newJString(parent))
  add(query_598007, "key", newJString(key))
  add(query_598007, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_598008 = body
  add(query_598007, "prettyPrint", newJBool(prettyPrint))
  result = call_598005.call(path_598006, query_598007, nil, nil, body_598008)

var cloudassetProjectsExportAssets* = Call_CloudassetProjectsExportAssets_597988(
    name: "cloudassetProjectsExportAssets", meth: HttpMethod.HttpPost,
    host: "cloudasset.googleapis.com", route: "/v1beta1/{parent}:exportAssets",
    validator: validate_CloudassetProjectsExportAssets_597989, base: "/",
    url: url_CloudassetProjectsExportAssets_597990, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
