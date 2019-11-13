
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "cloudasset"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_CloudassetOrganizationsOperationsGet_579635 = ref object of OpenApiRestCall_579364
proc url_CloudassetOrganizationsOperationsGet_579637(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudassetOrganizationsOperationsGet_579636(path: JsonNode;
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
  var valid_579763 = path.getOrDefault("name")
  valid_579763 = validateParameter(valid_579763, JString, required = true,
                                 default = nil)
  if valid_579763 != nil:
    section.add "name", valid_579763
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579764 = query.getOrDefault("key")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = nil)
  if valid_579764 != nil:
    section.add "key", valid_579764
  var valid_579778 = query.getOrDefault("prettyPrint")
  valid_579778 = validateParameter(valid_579778, JBool, required = false,
                                 default = newJBool(true))
  if valid_579778 != nil:
    section.add "prettyPrint", valid_579778
  var valid_579779 = query.getOrDefault("oauth_token")
  valid_579779 = validateParameter(valid_579779, JString, required = false,
                                 default = nil)
  if valid_579779 != nil:
    section.add "oauth_token", valid_579779
  var valid_579780 = query.getOrDefault("$.xgafv")
  valid_579780 = validateParameter(valid_579780, JString, required = false,
                                 default = newJString("1"))
  if valid_579780 != nil:
    section.add "$.xgafv", valid_579780
  var valid_579781 = query.getOrDefault("alt")
  valid_579781 = validateParameter(valid_579781, JString, required = false,
                                 default = newJString("json"))
  if valid_579781 != nil:
    section.add "alt", valid_579781
  var valid_579782 = query.getOrDefault("uploadType")
  valid_579782 = validateParameter(valid_579782, JString, required = false,
                                 default = nil)
  if valid_579782 != nil:
    section.add "uploadType", valid_579782
  var valid_579783 = query.getOrDefault("quotaUser")
  valid_579783 = validateParameter(valid_579783, JString, required = false,
                                 default = nil)
  if valid_579783 != nil:
    section.add "quotaUser", valid_579783
  var valid_579784 = query.getOrDefault("callback")
  valid_579784 = validateParameter(valid_579784, JString, required = false,
                                 default = nil)
  if valid_579784 != nil:
    section.add "callback", valid_579784
  var valid_579785 = query.getOrDefault("fields")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "fields", valid_579785
  var valid_579786 = query.getOrDefault("access_token")
  valid_579786 = validateParameter(valid_579786, JString, required = false,
                                 default = nil)
  if valid_579786 != nil:
    section.add "access_token", valid_579786
  var valid_579787 = query.getOrDefault("upload_protocol")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "upload_protocol", valid_579787
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_CloudassetOrganizationsOperationsGet_579635;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579881: Call_CloudassetOrganizationsOperationsGet_579635;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## cloudassetOrganizationsOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579882 = newJObject()
  var query_579884 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(query_579884, "$.xgafv", newJString(Xgafv))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "uploadType", newJString(uploadType))
  add(query_579884, "quotaUser", newJString(quotaUser))
  add(path_579882, "name", newJString(name))
  add(query_579884, "callback", newJString(callback))
  add(query_579884, "fields", newJString(fields))
  add(query_579884, "access_token", newJString(accessToken))
  add(query_579884, "upload_protocol", newJString(uploadProtocol))
  result = call_579881.call(path_579882, query_579884, nil, nil, nil)

var cloudassetOrganizationsOperationsGet* = Call_CloudassetOrganizationsOperationsGet_579635(
    name: "cloudassetOrganizationsOperationsGet", meth: HttpMethod.HttpGet,
    host: "cloudasset.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_CloudassetOrganizationsOperationsGet_579636, base: "/",
    url: url_CloudassetOrganizationsOperationsGet_579637, schemes: {Scheme.Https})
type
  Call_CloudassetOrganizationsBatchGetAssetsHistory_579923 = ref object of OpenApiRestCall_579364
proc url_CloudassetOrganizationsBatchGetAssetsHistory_579925(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":batchGetAssetsHistory")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudassetOrganizationsBatchGetAssetsHistory_579924(path: JsonNode;
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
  var valid_579926 = path.getOrDefault("parent")
  valid_579926 = validateParameter(valid_579926, JString, required = true,
                                 default = nil)
  if valid_579926 != nil:
    section.add "parent", valid_579926
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   contentType: JString
  ##              : Optional. The content type.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   readTimeWindow.startTime: JString
  ##                           : Start time of the time window (exclusive).
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   readTimeWindow.endTime: JString
  ##                         : End time of the time window (inclusive).
  ## Current timestamp if not specified.
  section = newJObject()
  var valid_579927 = query.getOrDefault("key")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "key", valid_579927
  var valid_579928 = query.getOrDefault("prettyPrint")
  valid_579928 = validateParameter(valid_579928, JBool, required = false,
                                 default = newJBool(true))
  if valid_579928 != nil:
    section.add "prettyPrint", valid_579928
  var valid_579929 = query.getOrDefault("oauth_token")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "oauth_token", valid_579929
  var valid_579930 = query.getOrDefault("$.xgafv")
  valid_579930 = validateParameter(valid_579930, JString, required = false,
                                 default = newJString("1"))
  if valid_579930 != nil:
    section.add "$.xgafv", valid_579930
  var valid_579931 = query.getOrDefault("contentType")
  valid_579931 = validateParameter(valid_579931, JString, required = false, default = newJString(
      "CONTENT_TYPE_UNSPECIFIED"))
  if valid_579931 != nil:
    section.add "contentType", valid_579931
  var valid_579932 = query.getOrDefault("alt")
  valid_579932 = validateParameter(valid_579932, JString, required = false,
                                 default = newJString("json"))
  if valid_579932 != nil:
    section.add "alt", valid_579932
  var valid_579933 = query.getOrDefault("uploadType")
  valid_579933 = validateParameter(valid_579933, JString, required = false,
                                 default = nil)
  if valid_579933 != nil:
    section.add "uploadType", valid_579933
  var valid_579934 = query.getOrDefault("assetNames")
  valid_579934 = validateParameter(valid_579934, JArray, required = false,
                                 default = nil)
  if valid_579934 != nil:
    section.add "assetNames", valid_579934
  var valid_579935 = query.getOrDefault("quotaUser")
  valid_579935 = validateParameter(valid_579935, JString, required = false,
                                 default = nil)
  if valid_579935 != nil:
    section.add "quotaUser", valid_579935
  var valid_579936 = query.getOrDefault("readTimeWindow.startTime")
  valid_579936 = validateParameter(valid_579936, JString, required = false,
                                 default = nil)
  if valid_579936 != nil:
    section.add "readTimeWindow.startTime", valid_579936
  var valid_579937 = query.getOrDefault("callback")
  valid_579937 = validateParameter(valid_579937, JString, required = false,
                                 default = nil)
  if valid_579937 != nil:
    section.add "callback", valid_579937
  var valid_579938 = query.getOrDefault("fields")
  valid_579938 = validateParameter(valid_579938, JString, required = false,
                                 default = nil)
  if valid_579938 != nil:
    section.add "fields", valid_579938
  var valid_579939 = query.getOrDefault("access_token")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "access_token", valid_579939
  var valid_579940 = query.getOrDefault("upload_protocol")
  valid_579940 = validateParameter(valid_579940, JString, required = false,
                                 default = nil)
  if valid_579940 != nil:
    section.add "upload_protocol", valid_579940
  var valid_579941 = query.getOrDefault("readTimeWindow.endTime")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "readTimeWindow.endTime", valid_579941
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579942: Call_CloudassetOrganizationsBatchGetAssetsHistory_579923;
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
  let valid = call_579942.validator(path, query, header, formData, body)
  let scheme = call_579942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579942.url(scheme.get, call_579942.host, call_579942.base,
                         call_579942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579942, url, valid)

proc call*(call_579943: Call_CloudassetOrganizationsBatchGetAssetsHistory_579923;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1";
          contentType: string = "CONTENT_TYPE_UNSPECIFIED"; alt: string = "json";
          uploadType: string = ""; assetNames: JsonNode = nil; quotaUser: string = "";
          readTimeWindowStartTime: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = "";
          readTimeWindowEndTime: string = ""): Recallable =
  ## cloudassetOrganizationsBatchGetAssetsHistory
  ## Batch gets the update history of assets that overlap a time window.
  ## For RESOURCE content, this API outputs history with asset in both
  ## non-delete or deleted status.
  ## For IAM_POLICY content, this API outputs history when the asset and its
  ## attached IAM POLICY both exist. This can create gaps in the output history.
  ## If a specified asset does not exist, this API returns an INVALID_ARGUMENT
  ## error.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   contentType: string
  ##              : Optional. The content type.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
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
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   readTimeWindowStartTime: string
  ##                          : Start time of the time window (exclusive).
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The relative name of the root asset. It can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id")", or a project number (such as "projects/12345").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   readTimeWindowEndTime: string
  ##                        : End time of the time window (inclusive).
  ## Current timestamp if not specified.
  var path_579944 = newJObject()
  var query_579945 = newJObject()
  add(query_579945, "key", newJString(key))
  add(query_579945, "prettyPrint", newJBool(prettyPrint))
  add(query_579945, "oauth_token", newJString(oauthToken))
  add(query_579945, "$.xgafv", newJString(Xgafv))
  add(query_579945, "contentType", newJString(contentType))
  add(query_579945, "alt", newJString(alt))
  add(query_579945, "uploadType", newJString(uploadType))
  if assetNames != nil:
    query_579945.add "assetNames", assetNames
  add(query_579945, "quotaUser", newJString(quotaUser))
  add(query_579945, "readTimeWindow.startTime",
      newJString(readTimeWindowStartTime))
  add(query_579945, "callback", newJString(callback))
  add(path_579944, "parent", newJString(parent))
  add(query_579945, "fields", newJString(fields))
  add(query_579945, "access_token", newJString(accessToken))
  add(query_579945, "upload_protocol", newJString(uploadProtocol))
  add(query_579945, "readTimeWindow.endTime", newJString(readTimeWindowEndTime))
  result = call_579943.call(path_579944, query_579945, nil, nil, nil)

var cloudassetOrganizationsBatchGetAssetsHistory* = Call_CloudassetOrganizationsBatchGetAssetsHistory_579923(
    name: "cloudassetOrganizationsBatchGetAssetsHistory",
    meth: HttpMethod.HttpGet, host: "cloudasset.googleapis.com",
    route: "/v1beta1/{parent}:batchGetAssetsHistory",
    validator: validate_CloudassetOrganizationsBatchGetAssetsHistory_579924,
    base: "/", url: url_CloudassetOrganizationsBatchGetAssetsHistory_579925,
    schemes: {Scheme.Https})
type
  Call_CloudassetOrganizationsExportAssets_579946 = ref object of OpenApiRestCall_579364
proc url_CloudassetOrganizationsExportAssets_579948(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: ":exportAssets")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_CloudassetOrganizationsExportAssets_579947(path: JsonNode;
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
  var valid_579949 = path.getOrDefault("parent")
  valid_579949 = validateParameter(valid_579949, JString, required = true,
                                 default = nil)
  if valid_579949 != nil:
    section.add "parent", valid_579949
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579950 = query.getOrDefault("key")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "key", valid_579950
  var valid_579951 = query.getOrDefault("prettyPrint")
  valid_579951 = validateParameter(valid_579951, JBool, required = false,
                                 default = newJBool(true))
  if valid_579951 != nil:
    section.add "prettyPrint", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("$.xgafv")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("1"))
  if valid_579953 != nil:
    section.add "$.xgafv", valid_579953
  var valid_579954 = query.getOrDefault("alt")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("json"))
  if valid_579954 != nil:
    section.add "alt", valid_579954
  var valid_579955 = query.getOrDefault("uploadType")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "uploadType", valid_579955
  var valid_579956 = query.getOrDefault("quotaUser")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "quotaUser", valid_579956
  var valid_579957 = query.getOrDefault("callback")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "callback", valid_579957
  var valid_579958 = query.getOrDefault("fields")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "fields", valid_579958
  var valid_579959 = query.getOrDefault("access_token")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "access_token", valid_579959
  var valid_579960 = query.getOrDefault("upload_protocol")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "upload_protocol", valid_579960
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

proc call*(call_579962: Call_CloudassetOrganizationsExportAssets_579946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Exports assets with time and resource types to a given Cloud Storage
  ## location. The output format is newline-delimited JSON.
  ## This API implements the google.longrunning.Operation API allowing you
  ## to keep track of the export.
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_CloudassetOrganizationsExportAssets_579946;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## cloudassetOrganizationsExportAssets
  ## Exports assets with time and resource types to a given Cloud Storage
  ## location. The output format is newline-delimited JSON.
  ## This API implements the google.longrunning.Operation API allowing you
  ## to keep track of the export.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The relative name of the root asset. This can only be an
  ## organization number (such as "organizations/123"), a project ID (such as
  ## "projects/my-project-id"), a project number (such as "projects/12345"), or
  ## a folder number (such as "folders/123").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579964 = newJObject()
  var query_579965 = newJObject()
  var body_579966 = newJObject()
  add(query_579965, "key", newJString(key))
  add(query_579965, "prettyPrint", newJBool(prettyPrint))
  add(query_579965, "oauth_token", newJString(oauthToken))
  add(query_579965, "$.xgafv", newJString(Xgafv))
  add(query_579965, "alt", newJString(alt))
  add(query_579965, "uploadType", newJString(uploadType))
  add(query_579965, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579966 = body
  add(query_579965, "callback", newJString(callback))
  add(path_579964, "parent", newJString(parent))
  add(query_579965, "fields", newJString(fields))
  add(query_579965, "access_token", newJString(accessToken))
  add(query_579965, "upload_protocol", newJString(uploadProtocol))
  result = call_579963.call(path_579964, query_579965, nil, nil, body_579966)

var cloudassetOrganizationsExportAssets* = Call_CloudassetOrganizationsExportAssets_579946(
    name: "cloudassetOrganizationsExportAssets", meth: HttpMethod.HttpPost,
    host: "cloudasset.googleapis.com", route: "/v1beta1/{parent}:exportAssets",
    validator: validate_CloudassetOrganizationsExportAssets_579947, base: "/",
    url: url_CloudassetOrganizationsExportAssets_579948, schemes: {Scheme.Https})
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
