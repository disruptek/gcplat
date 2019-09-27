
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Search Ads 360
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Reports and modifies your advertising data in DoubleClick Search (for example, campaigns, ad groups, keywords, and conversions).
## 
## https://developers.google.com/doubleclick-search/
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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
  gcpServiceName = "doubleclicksearch"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclicksearchConversionGet_593692 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchConversionGet_593694(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  assert "engineAccountId" in path, "`engineAccountId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/engine/"),
               (kind: VariableSegment, value: "engineAccountId"),
               (kind: ConstantSegment, value: "/conversion")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchConversionGet_593693(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `agencyId` field"
  var valid_593820 = path.getOrDefault("agencyId")
  valid_593820 = validateParameter(valid_593820, JString, required = true,
                                 default = nil)
  if valid_593820 != nil:
    section.add "agencyId", valid_593820
  var valid_593821 = path.getOrDefault("engineAccountId")
  valid_593821 = validateParameter(valid_593821, JString, required = true,
                                 default = nil)
  if valid_593821 != nil:
    section.add "engineAccountId", valid_593821
  var valid_593822 = path.getOrDefault("advertiserId")
  valid_593822 = validateParameter(valid_593822, JString, required = true,
                                 default = nil)
  if valid_593822 != nil:
    section.add "advertiserId", valid_593822
  result.add "path", section
  ## parameters in `query` object:
  ##   adGroupId: JString
  ##            : Numeric ID of the ad group.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   criterionId: JString
  ##              : Numeric ID of the criterion.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   adId: JString
  ##       : Numeric ID of the ad.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   campaignId: JString
  ##             : Numeric ID of the campaign.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  section = newJObject()
  var valid_593823 = query.getOrDefault("adGroupId")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "adGroupId", valid_593823
  var valid_593824 = query.getOrDefault("fields")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "fields", valid_593824
  var valid_593825 = query.getOrDefault("quotaUser")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "quotaUser", valid_593825
  var valid_593839 = query.getOrDefault("alt")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = newJString("json"))
  if valid_593839 != nil:
    section.add "alt", valid_593839
  assert query != nil, "query argument is necessary due to required `endDate` field"
  var valid_593840 = query.getOrDefault("endDate")
  valid_593840 = validateParameter(valid_593840, JInt, required = true, default = nil)
  if valid_593840 != nil:
    section.add "endDate", valid_593840
  var valid_593841 = query.getOrDefault("startDate")
  valid_593841 = validateParameter(valid_593841, JInt, required = true, default = nil)
  if valid_593841 != nil:
    section.add "startDate", valid_593841
  var valid_593842 = query.getOrDefault("criterionId")
  valid_593842 = validateParameter(valid_593842, JString, required = false,
                                 default = nil)
  if valid_593842 != nil:
    section.add "criterionId", valid_593842
  var valid_593843 = query.getOrDefault("oauth_token")
  valid_593843 = validateParameter(valid_593843, JString, required = false,
                                 default = nil)
  if valid_593843 != nil:
    section.add "oauth_token", valid_593843
  var valid_593844 = query.getOrDefault("userIp")
  valid_593844 = validateParameter(valid_593844, JString, required = false,
                                 default = nil)
  if valid_593844 != nil:
    section.add "userIp", valid_593844
  var valid_593845 = query.getOrDefault("adId")
  valid_593845 = validateParameter(valid_593845, JString, required = false,
                                 default = nil)
  if valid_593845 != nil:
    section.add "adId", valid_593845
  var valid_593846 = query.getOrDefault("key")
  valid_593846 = validateParameter(valid_593846, JString, required = false,
                                 default = nil)
  if valid_593846 != nil:
    section.add "key", valid_593846
  var valid_593847 = query.getOrDefault("startRow")
  valid_593847 = validateParameter(valid_593847, JInt, required = true, default = nil)
  if valid_593847 != nil:
    section.add "startRow", valid_593847
  var valid_593848 = query.getOrDefault("prettyPrint")
  valid_593848 = validateParameter(valid_593848, JBool, required = false,
                                 default = newJBool(true))
  if valid_593848 != nil:
    section.add "prettyPrint", valid_593848
  var valid_593849 = query.getOrDefault("campaignId")
  valid_593849 = validateParameter(valid_593849, JString, required = false,
                                 default = nil)
  if valid_593849 != nil:
    section.add "campaignId", valid_593849
  var valid_593850 = query.getOrDefault("rowCount")
  valid_593850 = validateParameter(valid_593850, JInt, required = true, default = nil)
  if valid_593850 != nil:
    section.add "rowCount", valid_593850
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593873: Call_DoubleclicksearchConversionGet_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ## 
  let valid = call_593873.validator(path, query, header, formData, body)
  let scheme = call_593873.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593873.url(scheme.get, call_593873.host, call_593873.base,
                         call_593873.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593873, url, valid)

proc call*(call_593944: Call_DoubleclicksearchConversionGet_593692; endDate: int;
          agencyId: string; engineAccountId: string; startDate: int; startRow: int;
          advertiserId: string; rowCount: int; adGroupId: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          criterionId: string = ""; oauthToken: string = ""; userIp: string = "";
          adId: string = ""; key: string = ""; prettyPrint: bool = true;
          campaignId: string = ""): Recallable =
  ## doubleclicksearchConversionGet
  ## Retrieves a list of conversions from a DoubleClick Search engine account.
  ##   adGroupId: string
  ##            : Numeric ID of the ad group.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   criterionId: string
  ##              : Numeric ID of the criterion.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   adId: string
  ##       : Numeric ID of the ad.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   campaignId: string
  ##             : Numeric ID of the campaign.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  var path_593945 = newJObject()
  var query_593947 = newJObject()
  add(query_593947, "adGroupId", newJString(adGroupId))
  add(query_593947, "fields", newJString(fields))
  add(query_593947, "quotaUser", newJString(quotaUser))
  add(query_593947, "alt", newJString(alt))
  add(query_593947, "endDate", newJInt(endDate))
  add(path_593945, "agencyId", newJString(agencyId))
  add(path_593945, "engineAccountId", newJString(engineAccountId))
  add(query_593947, "startDate", newJInt(startDate))
  add(query_593947, "criterionId", newJString(criterionId))
  add(query_593947, "oauth_token", newJString(oauthToken))
  add(query_593947, "userIp", newJString(userIp))
  add(query_593947, "adId", newJString(adId))
  add(query_593947, "key", newJString(key))
  add(query_593947, "startRow", newJInt(startRow))
  add(path_593945, "advertiserId", newJString(advertiserId))
  add(query_593947, "prettyPrint", newJBool(prettyPrint))
  add(query_593947, "campaignId", newJString(campaignId))
  add(query_593947, "rowCount", newJInt(rowCount))
  result = call_593944.call(path_593945, query_593947, nil, nil, nil)

var doubleclicksearchConversionGet* = Call_DoubleclicksearchConversionGet_593692(
    name: "doubleclicksearchConversionGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/agency/{agencyId}/advertiser/{advertiserId}/engine/{engineAccountId}/conversion",
    validator: validate_DoubleclicksearchConversionGet_593693,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionGet_593694,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchSavedColumnsList_593986 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchSavedColumnsList_593988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "agencyId" in path, "`agencyId` is a required path parameter"
  assert "advertiserId" in path, "`advertiserId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/agency/"),
               (kind: VariableSegment, value: "agencyId"),
               (kind: ConstantSegment, value: "/advertiser/"),
               (kind: VariableSegment, value: "advertiserId"),
               (kind: ConstantSegment, value: "/savedcolumns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchSavedColumnsList_593987(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   agencyId: JString (required)
  ##           : DS ID of the agency.
  ##   advertiserId: JString (required)
  ##               : DS ID of the advertiser.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `agencyId` field"
  var valid_593989 = path.getOrDefault("agencyId")
  valid_593989 = validateParameter(valid_593989, JString, required = true,
                                 default = nil)
  if valid_593989 != nil:
    section.add "agencyId", valid_593989
  var valid_593990 = path.getOrDefault("advertiserId")
  valid_593990 = validateParameter(valid_593990, JString, required = true,
                                 default = nil)
  if valid_593990 != nil:
    section.add "advertiserId", valid_593990
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
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
  var valid_593995 = query.getOrDefault("userIp")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "userIp", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("prettyPrint")
  valid_593997 = validateParameter(valid_593997, JBool, required = false,
                                 default = newJBool(true))
  if valid_593997 != nil:
    section.add "prettyPrint", valid_593997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593998: Call_DoubleclicksearchSavedColumnsList_593986;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieve the list of saved columns for a specified advertiser.
  ## 
  let valid = call_593998.validator(path, query, header, formData, body)
  let scheme = call_593998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593998.url(scheme.get, call_593998.host, call_593998.base,
                         call_593998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593998, url, valid)

proc call*(call_593999: Call_DoubleclicksearchSavedColumnsList_593986;
          agencyId: string; advertiserId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchSavedColumnsList
  ## Retrieve the list of saved columns for a specified advertiser.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   agencyId: string (required)
  ##           : DS ID of the agency.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   advertiserId: string (required)
  ##               : DS ID of the advertiser.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594000 = newJObject()
  var query_594001 = newJObject()
  add(query_594001, "fields", newJString(fields))
  add(query_594001, "quotaUser", newJString(quotaUser))
  add(query_594001, "alt", newJString(alt))
  add(path_594000, "agencyId", newJString(agencyId))
  add(query_594001, "oauth_token", newJString(oauthToken))
  add(query_594001, "userIp", newJString(userIp))
  add(query_594001, "key", newJString(key))
  add(path_594000, "advertiserId", newJString(advertiserId))
  add(query_594001, "prettyPrint", newJBool(prettyPrint))
  result = call_593999.call(path_594000, query_594001, nil, nil, nil)

var doubleclicksearchSavedColumnsList* = Call_DoubleclicksearchSavedColumnsList_593986(
    name: "doubleclicksearchSavedColumnsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/agency/{agencyId}/advertiser/{advertiserId}/savedcolumns",
    validator: validate_DoubleclicksearchSavedColumnsList_593987,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchSavedColumnsList_593988,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdate_594002 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchConversionUpdate_594004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdate_594003(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594005 = query.getOrDefault("fields")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "fields", valid_594005
  var valid_594006 = query.getOrDefault("quotaUser")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "quotaUser", valid_594006
  var valid_594007 = query.getOrDefault("alt")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = newJString("json"))
  if valid_594007 != nil:
    section.add "alt", valid_594007
  var valid_594008 = query.getOrDefault("oauth_token")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "oauth_token", valid_594008
  var valid_594009 = query.getOrDefault("userIp")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "userIp", valid_594009
  var valid_594010 = query.getOrDefault("key")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "key", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
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

proc call*(call_594013: Call_DoubleclicksearchConversionUpdate_594002;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_DoubleclicksearchConversionUpdate_594002;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionUpdate
  ## Updates a batch of conversions in DoubleClick Search.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594015 = newJObject()
  var body_594016 = newJObject()
  add(query_594015, "fields", newJString(fields))
  add(query_594015, "quotaUser", newJString(quotaUser))
  add(query_594015, "alt", newJString(alt))
  add(query_594015, "oauth_token", newJString(oauthToken))
  add(query_594015, "userIp", newJString(userIp))
  add(query_594015, "key", newJString(key))
  if body != nil:
    body_594016 = body
  add(query_594015, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(nil, query_594015, nil, nil, body_594016)

var doubleclicksearchConversionUpdate* = Call_DoubleclicksearchConversionUpdate_594002(
    name: "doubleclicksearchConversionUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionUpdate_594003,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionUpdate_594004,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionInsert_594017 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchConversionInsert_594019(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionInsert_594018(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a batch of new conversions into DoubleClick Search.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594020 = query.getOrDefault("fields")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "fields", valid_594020
  var valid_594021 = query.getOrDefault("quotaUser")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "quotaUser", valid_594021
  var valid_594022 = query.getOrDefault("alt")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = newJString("json"))
  if valid_594022 != nil:
    section.add "alt", valid_594022
  var valid_594023 = query.getOrDefault("oauth_token")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "oauth_token", valid_594023
  var valid_594024 = query.getOrDefault("userIp")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "userIp", valid_594024
  var valid_594025 = query.getOrDefault("key")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "key", valid_594025
  var valid_594026 = query.getOrDefault("prettyPrint")
  valid_594026 = validateParameter(valid_594026, JBool, required = false,
                                 default = newJBool(true))
  if valid_594026 != nil:
    section.add "prettyPrint", valid_594026
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

proc call*(call_594028: Call_DoubleclicksearchConversionInsert_594017;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a batch of new conversions into DoubleClick Search.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_DoubleclicksearchConversionInsert_594017;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionInsert
  ## Inserts a batch of new conversions into DoubleClick Search.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594030 = newJObject()
  var body_594031 = newJObject()
  add(query_594030, "fields", newJString(fields))
  add(query_594030, "quotaUser", newJString(quotaUser))
  add(query_594030, "alt", newJString(alt))
  add(query_594030, "oauth_token", newJString(oauthToken))
  add(query_594030, "userIp", newJString(userIp))
  add(query_594030, "key", newJString(key))
  if body != nil:
    body_594031 = body
  add(query_594030, "prettyPrint", newJBool(prettyPrint))
  result = call_594029.call(nil, query_594030, nil, nil, body_594031)

var doubleclicksearchConversionInsert* = Call_DoubleclicksearchConversionInsert_594017(
    name: "doubleclicksearchConversionInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionInsert_594018,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionInsert_594019,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionPatch_594032 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchConversionPatch_594034(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionPatch_594033(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   agencyId: JString (required)
  ##           : Numeric ID of the agency.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   endDate: JInt (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: JInt (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   advertiserId: JString (required)
  ##               : Numeric ID of the advertiser.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: JInt (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   engineAccountId: JString (required)
  ##                  : Numeric ID of the engine account.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   rowCount: JInt (required)
  ##           : The number of conversions to return per call.
  section = newJObject()
  assert query != nil,
        "query argument is necessary due to required `agencyId` field"
  var valid_594035 = query.getOrDefault("agencyId")
  valid_594035 = validateParameter(valid_594035, JString, required = true,
                                 default = nil)
  if valid_594035 != nil:
    section.add "agencyId", valid_594035
  var valid_594036 = query.getOrDefault("fields")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "fields", valid_594036
  var valid_594037 = query.getOrDefault("quotaUser")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "quotaUser", valid_594037
  var valid_594038 = query.getOrDefault("alt")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = newJString("json"))
  if valid_594038 != nil:
    section.add "alt", valid_594038
  var valid_594039 = query.getOrDefault("endDate")
  valid_594039 = validateParameter(valid_594039, JInt, required = true, default = nil)
  if valid_594039 != nil:
    section.add "endDate", valid_594039
  var valid_594040 = query.getOrDefault("startDate")
  valid_594040 = validateParameter(valid_594040, JInt, required = true, default = nil)
  if valid_594040 != nil:
    section.add "startDate", valid_594040
  var valid_594041 = query.getOrDefault("advertiserId")
  valid_594041 = validateParameter(valid_594041, JString, required = true,
                                 default = nil)
  if valid_594041 != nil:
    section.add "advertiserId", valid_594041
  var valid_594042 = query.getOrDefault("oauth_token")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "oauth_token", valid_594042
  var valid_594043 = query.getOrDefault("userIp")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "userIp", valid_594043
  var valid_594044 = query.getOrDefault("key")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "key", valid_594044
  var valid_594045 = query.getOrDefault("startRow")
  valid_594045 = validateParameter(valid_594045, JInt, required = true, default = nil)
  if valid_594045 != nil:
    section.add "startRow", valid_594045
  var valid_594046 = query.getOrDefault("engineAccountId")
  valid_594046 = validateParameter(valid_594046, JString, required = true,
                                 default = nil)
  if valid_594046 != nil:
    section.add "engineAccountId", valid_594046
  var valid_594047 = query.getOrDefault("prettyPrint")
  valid_594047 = validateParameter(valid_594047, JBool, required = false,
                                 default = newJBool(true))
  if valid_594047 != nil:
    section.add "prettyPrint", valid_594047
  var valid_594048 = query.getOrDefault("rowCount")
  valid_594048 = validateParameter(valid_594048, JInt, required = true, default = nil)
  if valid_594048 != nil:
    section.add "rowCount", valid_594048
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

proc call*(call_594050: Call_DoubleclicksearchConversionPatch_594032;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_DoubleclicksearchConversionPatch_594032;
          agencyId: string; endDate: int; startDate: int; advertiserId: string;
          startRow: int; engineAccountId: string; rowCount: int; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionPatch
  ## Updates a batch of conversions in DoubleClick Search. This method supports patch semantics.
  ##   agencyId: string (required)
  ##           : Numeric ID of the agency.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   endDate: int (required)
  ##          : Last date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   startDate: int (required)
  ##            : First date (inclusive) on which to retrieve conversions. Format is yyyymmdd.
  ##   advertiserId: string (required)
  ##               : Numeric ID of the advertiser.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   startRow: int (required)
  ##           : The 0-based starting index for retrieving conversions results.
  ##   engineAccountId: string (required)
  ##                  : Numeric ID of the engine account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   rowCount: int (required)
  ##           : The number of conversions to return per call.
  var query_594052 = newJObject()
  var body_594053 = newJObject()
  add(query_594052, "agencyId", newJString(agencyId))
  add(query_594052, "fields", newJString(fields))
  add(query_594052, "quotaUser", newJString(quotaUser))
  add(query_594052, "alt", newJString(alt))
  add(query_594052, "endDate", newJInt(endDate))
  add(query_594052, "startDate", newJInt(startDate))
  add(query_594052, "advertiserId", newJString(advertiserId))
  add(query_594052, "oauth_token", newJString(oauthToken))
  add(query_594052, "userIp", newJString(userIp))
  add(query_594052, "key", newJString(key))
  add(query_594052, "startRow", newJInt(startRow))
  add(query_594052, "engineAccountId", newJString(engineAccountId))
  if body != nil:
    body_594053 = body
  add(query_594052, "prettyPrint", newJBool(prettyPrint))
  add(query_594052, "rowCount", newJInt(rowCount))
  result = call_594051.call(nil, query_594052, nil, nil, body_594053)

var doubleclicksearchConversionPatch* = Call_DoubleclicksearchConversionPatch_594032(
    name: "doubleclicksearchConversionPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/conversion",
    validator: validate_DoubleclicksearchConversionPatch_594033,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchConversionPatch_594034,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchConversionUpdateAvailability_594054 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchConversionUpdateAvailability_594056(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchConversionUpdateAvailability_594055(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594057 = query.getOrDefault("fields")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "fields", valid_594057
  var valid_594058 = query.getOrDefault("quotaUser")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "quotaUser", valid_594058
  var valid_594059 = query.getOrDefault("alt")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = newJString("json"))
  if valid_594059 != nil:
    section.add "alt", valid_594059
  var valid_594060 = query.getOrDefault("oauth_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "oauth_token", valid_594060
  var valid_594061 = query.getOrDefault("userIp")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "userIp", valid_594061
  var valid_594062 = query.getOrDefault("key")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "key", valid_594062
  var valid_594063 = query.getOrDefault("prettyPrint")
  valid_594063 = validateParameter(valid_594063, JBool, required = false,
                                 default = newJBool(true))
  if valid_594063 != nil:
    section.add "prettyPrint", valid_594063
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   empty: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_DoubleclicksearchConversionUpdateAvailability_594054;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_DoubleclicksearchConversionUpdateAvailability_594054;
          empty: JsonNode = nil; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchConversionUpdateAvailability
  ## Updates the availabilities of a batch of floodlight activities in DoubleClick Search.
  ##   empty: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594067 = newJObject()
  var body_594068 = newJObject()
  if empty != nil:
    body_594068 = empty
  add(query_594067, "fields", newJString(fields))
  add(query_594067, "quotaUser", newJString(quotaUser))
  add(query_594067, "alt", newJString(alt))
  add(query_594067, "oauth_token", newJString(oauthToken))
  add(query_594067, "userIp", newJString(userIp))
  add(query_594067, "key", newJString(key))
  add(query_594067, "prettyPrint", newJBool(prettyPrint))
  result = call_594066.call(nil, query_594067, nil, nil, body_594068)

var doubleclicksearchConversionUpdateAvailability* = Call_DoubleclicksearchConversionUpdateAvailability_594054(
    name: "doubleclicksearchConversionUpdateAvailability",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/conversion/updateAvailability",
    validator: validate_DoubleclicksearchConversionUpdateAvailability_594055,
    base: "/doubleclicksearch/v2",
    url: url_DoubleclicksearchConversionUpdateAvailability_594056,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsRequest_594069 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchReportsRequest_594071(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsRequest_594070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a report request into the reporting system.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594072 = query.getOrDefault("fields")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "fields", valid_594072
  var valid_594073 = query.getOrDefault("quotaUser")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "quotaUser", valid_594073
  var valid_594074 = query.getOrDefault("alt")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("json"))
  if valid_594074 != nil:
    section.add "alt", valid_594074
  var valid_594075 = query.getOrDefault("oauth_token")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "oauth_token", valid_594075
  var valid_594076 = query.getOrDefault("userIp")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "userIp", valid_594076
  var valid_594077 = query.getOrDefault("key")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "key", valid_594077
  var valid_594078 = query.getOrDefault("prettyPrint")
  valid_594078 = validateParameter(valid_594078, JBool, required = false,
                                 default = newJBool(true))
  if valid_594078 != nil:
    section.add "prettyPrint", valid_594078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594080: Call_DoubleclicksearchReportsRequest_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a report request into the reporting system.
  ## 
  let valid = call_594080.validator(path, query, header, formData, body)
  let scheme = call_594080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594080.url(scheme.get, call_594080.host, call_594080.base,
                         call_594080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594080, url, valid)

proc call*(call_594081: Call_DoubleclicksearchReportsRequest_594069;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          reportRequest: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsRequest
  ## Inserts a report request into the reporting system.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   reportRequest: JObject
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594082 = newJObject()
  var body_594083 = newJObject()
  add(query_594082, "fields", newJString(fields))
  add(query_594082, "quotaUser", newJString(quotaUser))
  add(query_594082, "alt", newJString(alt))
  if reportRequest != nil:
    body_594083 = reportRequest
  add(query_594082, "oauth_token", newJString(oauthToken))
  add(query_594082, "userIp", newJString(userIp))
  add(query_594082, "key", newJString(key))
  add(query_594082, "prettyPrint", newJBool(prettyPrint))
  result = call_594081.call(nil, query_594082, nil, nil, body_594083)

var doubleclicksearchReportsRequest* = Call_DoubleclicksearchReportsRequest_594069(
    name: "doubleclicksearchReportsRequest", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports",
    validator: validate_DoubleclicksearchReportsRequest_594070,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsRequest_594071,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGenerate_594084 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchReportsGenerate_594086(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_DoubleclicksearchReportsGenerate_594085(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generates and returns a report immediately.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594087 = query.getOrDefault("fields")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "fields", valid_594087
  var valid_594088 = query.getOrDefault("quotaUser")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "quotaUser", valid_594088
  var valid_594089 = query.getOrDefault("alt")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("json"))
  if valid_594089 != nil:
    section.add "alt", valid_594089
  var valid_594090 = query.getOrDefault("oauth_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "oauth_token", valid_594090
  var valid_594091 = query.getOrDefault("userIp")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "userIp", valid_594091
  var valid_594092 = query.getOrDefault("key")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "key", valid_594092
  var valid_594093 = query.getOrDefault("prettyPrint")
  valid_594093 = validateParameter(valid_594093, JBool, required = false,
                                 default = newJBool(true))
  if valid_594093 != nil:
    section.add "prettyPrint", valid_594093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   reportRequest: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594095: Call_DoubleclicksearchReportsGenerate_594084;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates and returns a report immediately.
  ## 
  let valid = call_594095.validator(path, query, header, formData, body)
  let scheme = call_594095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594095.url(scheme.get, call_594095.host, call_594095.base,
                         call_594095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594095, url, valid)

proc call*(call_594096: Call_DoubleclicksearchReportsGenerate_594084;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          reportRequest: JsonNode = nil; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGenerate
  ## Generates and returns a report immediately.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   reportRequest: JObject
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594097 = newJObject()
  var body_594098 = newJObject()
  add(query_594097, "fields", newJString(fields))
  add(query_594097, "quotaUser", newJString(quotaUser))
  add(query_594097, "alt", newJString(alt))
  if reportRequest != nil:
    body_594098 = reportRequest
  add(query_594097, "oauth_token", newJString(oauthToken))
  add(query_594097, "userIp", newJString(userIp))
  add(query_594097, "key", newJString(key))
  add(query_594097, "prettyPrint", newJBool(prettyPrint))
  result = call_594096.call(nil, query_594097, nil, nil, body_594098)

var doubleclicksearchReportsGenerate* = Call_DoubleclicksearchReportsGenerate_594084(
    name: "doubleclicksearchReportsGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/reports/generate",
    validator: validate_DoubleclicksearchReportsGenerate_594085,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGenerate_594086,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGet_594099 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchReportsGet_594101(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGet_594100(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Polls for the status of a report request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportId: JString (required)
  ##           : ID of the report request being polled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `reportId` field"
  var valid_594102 = path.getOrDefault("reportId")
  valid_594102 = validateParameter(valid_594102, JString, required = true,
                                 default = nil)
  if valid_594102 != nil:
    section.add "reportId", valid_594102
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594103 = query.getOrDefault("fields")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = nil)
  if valid_594103 != nil:
    section.add "fields", valid_594103
  var valid_594104 = query.getOrDefault("quotaUser")
  valid_594104 = validateParameter(valid_594104, JString, required = false,
                                 default = nil)
  if valid_594104 != nil:
    section.add "quotaUser", valid_594104
  var valid_594105 = query.getOrDefault("alt")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = newJString("json"))
  if valid_594105 != nil:
    section.add "alt", valid_594105
  var valid_594106 = query.getOrDefault("oauth_token")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "oauth_token", valid_594106
  var valid_594107 = query.getOrDefault("userIp")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "userIp", valid_594107
  var valid_594108 = query.getOrDefault("key")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "key", valid_594108
  var valid_594109 = query.getOrDefault("prettyPrint")
  valid_594109 = validateParameter(valid_594109, JBool, required = false,
                                 default = newJBool(true))
  if valid_594109 != nil:
    section.add "prettyPrint", valid_594109
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594110: Call_DoubleclicksearchReportsGet_594099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Polls for the status of a report request.
  ## 
  let valid = call_594110.validator(path, query, header, formData, body)
  let scheme = call_594110.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594110.url(scheme.get, call_594110.host, call_594110.base,
                         call_594110.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594110, url, valid)

proc call*(call_594111: Call_DoubleclicksearchReportsGet_594099; reportId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGet
  ## Polls for the status of a report request.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   reportId: string (required)
  ##           : ID of the report request being polled.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594112 = newJObject()
  var query_594113 = newJObject()
  add(query_594113, "fields", newJString(fields))
  add(query_594113, "quotaUser", newJString(quotaUser))
  add(query_594113, "alt", newJString(alt))
  add(query_594113, "oauth_token", newJString(oauthToken))
  add(query_594113, "userIp", newJString(userIp))
  add(query_594113, "key", newJString(key))
  add(path_594112, "reportId", newJString(reportId))
  add(query_594113, "prettyPrint", newJBool(prettyPrint))
  result = call_594111.call(path_594112, query_594113, nil, nil, nil)

var doubleclicksearchReportsGet* = Call_DoubleclicksearchReportsGet_594099(
    name: "doubleclicksearchReportsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/reports/{reportId}",
    validator: validate_DoubleclicksearchReportsGet_594100,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGet_594101,
    schemes: {Scheme.Https})
type
  Call_DoubleclicksearchReportsGetFile_594114 = ref object of OpenApiRestCall_593424
proc url_DoubleclicksearchReportsGetFile_594116(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "reportId" in path, "`reportId` is a required path parameter"
  assert "reportFragment" in path, "`reportFragment` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/reports/"),
               (kind: VariableSegment, value: "reportId"),
               (kind: ConstantSegment, value: "/files/"),
               (kind: VariableSegment, value: "reportFragment")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclicksearchReportsGetFile_594115(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Downloads a report file encoded in UTF-8.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   reportFragment: JInt (required)
  ##                 : The index of the report fragment to download.
  ##   reportId: JString (required)
  ##           : ID of the report.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `reportFragment` field"
  var valid_594117 = path.getOrDefault("reportFragment")
  valid_594117 = validateParameter(valid_594117, JInt, required = true, default = nil)
  if valid_594117 != nil:
    section.add "reportFragment", valid_594117
  var valid_594118 = path.getOrDefault("reportId")
  valid_594118 = validateParameter(valid_594118, JString, required = true,
                                 default = nil)
  if valid_594118 != nil:
    section.add "reportId", valid_594118
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594119 = query.getOrDefault("fields")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "fields", valid_594119
  var valid_594120 = query.getOrDefault("quotaUser")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "quotaUser", valid_594120
  var valid_594121 = query.getOrDefault("alt")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = newJString("json"))
  if valid_594121 != nil:
    section.add "alt", valid_594121
  var valid_594122 = query.getOrDefault("oauth_token")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "oauth_token", valid_594122
  var valid_594123 = query.getOrDefault("userIp")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "userIp", valid_594123
  var valid_594124 = query.getOrDefault("key")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "key", valid_594124
  var valid_594125 = query.getOrDefault("prettyPrint")
  valid_594125 = validateParameter(valid_594125, JBool, required = false,
                                 default = newJBool(true))
  if valid_594125 != nil:
    section.add "prettyPrint", valid_594125
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594126: Call_DoubleclicksearchReportsGetFile_594114;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Downloads a report file encoded in UTF-8.
  ## 
  let valid = call_594126.validator(path, query, header, formData, body)
  let scheme = call_594126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594126.url(scheme.get, call_594126.host, call_594126.base,
                         call_594126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594126, url, valid)

proc call*(call_594127: Call_DoubleclicksearchReportsGetFile_594114;
          reportFragment: int; reportId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclicksearchReportsGetFile
  ## Downloads a report file encoded in UTF-8.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   reportFragment: int (required)
  ##                 : The index of the report fragment to download.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   reportId: string (required)
  ##           : ID of the report.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594128 = newJObject()
  var query_594129 = newJObject()
  add(query_594129, "fields", newJString(fields))
  add(path_594128, "reportFragment", newJInt(reportFragment))
  add(query_594129, "quotaUser", newJString(quotaUser))
  add(query_594129, "alt", newJString(alt))
  add(query_594129, "oauth_token", newJString(oauthToken))
  add(query_594129, "userIp", newJString(userIp))
  add(query_594129, "key", newJString(key))
  add(path_594128, "reportId", newJString(reportId))
  add(query_594129, "prettyPrint", newJBool(prettyPrint))
  result = call_594127.call(path_594128, query_594129, nil, nil, nil)

var doubleclicksearchReportsGetFile* = Call_DoubleclicksearchReportsGetFile_594114(
    name: "doubleclicksearchReportsGetFile", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/reports/{reportId}/files/{reportFragment}",
    validator: validate_DoubleclicksearchReportsGetFile_594115,
    base: "/doubleclicksearch/v2", url: url_DoubleclicksearchReportsGetFile_594116,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
